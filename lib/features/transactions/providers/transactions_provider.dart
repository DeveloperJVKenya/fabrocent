import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/isar_service.dart';
import '../../../core/models/financial_period.dart';
import '../../../core/models/transaction.dart';
import '../../../core/models/transaction_category.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/web_data_providers.dart';
import '../../../core/services/app_logger.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/sms/sms_channel.dart';
import '../../../core/sms/sms_parser.dart';

// ─── Current period ──────────────────────────────────────────────────────

final activePeriodProvider = FutureProvider<FinancialPeriod?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  if (kIsWeb) return FinancialPeriod.forMonth(DateTime.now(), user.uid);
  return IsarService.getActivePeriod(user.uid);
});

// ─── Transactions for the active period ──────────────────────────────────

final periodTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  if (kIsWeb) {
    // On web, bridge the Firestore StreamProvider into our own stream so the
    // rest of the app stays provider-agnostic.
    final controller = StreamController<List<Transaction>>();
    ref.listen<AsyncValue<List<Transaction>>>(
      webTransactionsProvider,
      (_, next) => controller.add(next.valueOrNull ?? []),
      fireImmediately: true,
    );
    ref.onDispose(controller.close);
    return controller.stream;
  }

  final user = ref.watch(currentUserProvider);
  final periodAsync = ref.watch(activePeriodProvider);

  if (user == null) return Stream.value([]);

  return periodAsync.when(
    data: (period) {
      if (period == null) return Stream.value([]);
      return IsarService.watchTransactions(
        userId: user.uid,
        start: period.startDate,
        end: period.endDate,
      );
    },
    loading: () => Stream.value([]),
    error: (_, _) => Stream.value([]),
  );
});

// ─── Untagged transactions count ─────────────────────────────────────────

final untaggedCountProvider = FutureProvider<int>((ref) async {
  if (kIsWeb) return 0;
  final user = ref.watch(currentUserProvider);
  if (user == null) return 0;
  final untagged = await IsarService.getUntaggedTransactions(user.uid);
  return untagged.length;
});

// ─── SMS import notifier ─────────────────────────────────────────────────

class SmsImportState {
  final bool isLoading;
  final int imported;
  final int total;
  final String? error;

  const SmsImportState({
    this.isLoading = false,
    this.imported = 0,
    this.total = 0,
    this.error,
  });

  SmsImportState copyWith({
    bool? isLoading,
    int? imported,
    int? total,
    String? error,
  }) => SmsImportState(
    isLoading: isLoading ?? this.isLoading,
    imported: imported ?? this.imported,
    total: total ?? this.total,
    error: error,
  );
}

class SmsImportNotifier extends StateNotifier<SmsImportState> {
  final Ref _ref;
  StreamSubscription<SmsMessage>? _smsSub;

  SmsImportNotifier(this._ref) : super(const SmsImportState());

  @override
  void dispose() {
    _smsSub?.cancel();
    super.dispose();
  }

  Future<void> importHistoricalSms() async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      AppLogger.sms('importHistoricalSms: no user — skipping');
      return;
    }

    AppLogger.sms('Starting historical SMS import for uid=${user.uid}');
    state = state.copyWith(isLoading: true);

    try {
      final messages = await SmsChannel.getInboxSms(address: 'M-PESA');
      AppLogger.sms('Read ${messages.length} M-Pesa SMS from inbox');

      state = state.copyWith(total: messages.length);

      final rawList = messages
          .map((m) => {'address': m.address, 'body': m.body, 'date': m.date})
          .toList();

      final transactions = SmsParser.parseAll(rawList, user.uid);
      AppLogger.sms('Parsed ${transactions.length} valid transaction(s) from ${messages.length} SMS');

      for (final txn in transactions) {
        txn.periodId = FinancialPeriod.idForDate(txn.dateTime);
      }

      await IsarService.saveTransactions(transactions);
      await _ensureActivePeriod(user.uid);

      AppLogger.sms('✅ Import complete — ${transactions.length} transaction(s) saved');
      state = state.copyWith(
        isLoading: false,
        imported: transactions.length,
      );
    } catch (e, st) {
      AppLogger.error('📱 SMS', 'Historical SMS import failed', e, st);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> _ensureActivePeriod(String userId) async {
    final existing = await IsarService.getActivePeriod(userId);
    if (existing == null) {
      final period = FinancialPeriod.forMonth(DateTime.now(), userId);
      await IsarService.savePeriod(period);
    }
  }

  void startListening() {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      AppLogger.sms('startListening: no user — not subscribing to incoming SMS');
      return;
    }

    AppLogger.sms('Subscribing to incoming SMS stream for uid=${user.uid}');
    _smsSub?.cancel();
    _smsSub = SmsChannel.incomingSmsStream.listen((message) async {
      if (!SmsParser.isMpesaSms(message.address)) return;
      AppLogger.sms('Incoming M-Pesa SMS from ${message.address} — parsing...');
      final txn = SmsParser.parse(message.body, user.uid);
      if (txn == null) {
        AppLogger.sms('SMS did not parse to a transaction — skipped');
        return;
      }
      txn.periodId = FinancialPeriod.idForDate(txn.dateTime);
      await IsarService.saveTransaction(txn);
      AppLogger.sms('✅ Incoming SMS saved — ${txn.formattedAmount} (${txn.type.name})');
    });
  }
}

final smsImportProvider =
    StateNotifierProvider<SmsImportNotifier, SmsImportState>((ref) {
  return SmsImportNotifier(ref);
});

// ─── Category update ──────────────────────────────────────────────────────

class CategoryUpdateNotifier extends StateNotifier<AsyncValue<void>> {
  CategoryUpdateNotifier() : super(const AsyncData(null));

  Future<void> updateCategory({
    required int transactionId,
    required TransactionCategoryId categoryId,
  }) async {
    AppLogger.sms('Updating category: txn#$transactionId → ${categoryId.name}');
    state = const AsyncLoading();
    try {
      await IsarService.updateTransactionCategory(
        id: transactionId,
        categoryId: categoryId,
        confirmed: true,
      );
      AppLogger.sms('✅ Category updated: txn#$transactionId → ${categoryId.name}');
      state = const AsyncData(null);
      _checkBudgetThreshold(transactionId, categoryId).ignore();
    } catch (e, st) {
      AppLogger.error('📱 SMS', 'Failed to update category for txn#$transactionId', e, st);
      state = AsyncError(e, st);
    }
  }

  Future<void> _checkBudgetThreshold(
    int transactionId,
    TransactionCategoryId categoryId,
  ) async {
    final txn = await IsarService.getTransactionById(transactionId);
    if (txn == null || txn.isCredit || txn.periodId == null) return;

    final period = await IsarService.getActivePeriod(txn.userId);
    if (period == null) return;

    final allocations = await IsarService.getBudgetAllocations(
      userId: txn.userId,
      periodId: period.periodId,
    );

    final alloc =
        allocations.where((a) => a.categoryId == categoryId).firstOrNull;
    if (alloc == null || alloc.allocatedAmount <= 0) return;

    final spent = await IsarService.getCategoryTotal(
      userId: txn.userId,
      start: period.startDate,
      end: period.endDate,
      categoryId: categoryId,
    );

    final usagePct = (spent / alloc.allocatedAmount) * 100;

    AppLogger.budget(
      'Budget check for ${categoryId.name}: '
      'spent=${spent.toStringAsFixed(0)} / allocated=${alloc.allocatedAmount.toStringAsFixed(0)} '
      '(${usagePct.toStringAsFixed(1)}%)',
    );

    if (!alloc.alert100Sent && usagePct >= 100) {
      AppLogger.budget('🚨 Budget 100% reached for ${categoryId.name} — sending alert');
      await NotificationService.showBudgetAlert(
        categoryName: alloc.category.name,
        usagePercent: usagePct,
        spentAmount: spent,
        allocatedAmount: alloc.allocatedAmount,
      );
      alloc.alert100Sent = true;
      await IsarService.saveBudgetAllocation(alloc);
    } else if (!alloc.alert80Sent && usagePct >= 80) {
      AppLogger.budget('⚠️ Budget 80% reached for ${categoryId.name} — sending alert');
      await NotificationService.showBudgetAlert(
        categoryName: alloc.category.name,
        usagePercent: usagePct,
        spentAmount: spent,
        allocatedAmount: alloc.allocatedAmount,
      );
      alloc.alert80Sent = true;
      await IsarService.saveBudgetAllocation(alloc);
    }
  }
}

final categoryUpdateProvider =
    StateNotifierProvider<CategoryUpdateNotifier, AsyncValue<void>>(
        (_) => CategoryUpdateNotifier());
