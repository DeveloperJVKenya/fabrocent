import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/models/budget.dart';
import '../../../core/models/transaction_category.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/services/app_logger.dart';
import '../../transactions/providers/transactions_provider.dart';

// ─── Active budget plan ───────────────────────────────────────────────────

final activeBudgetPlanProvider = FutureProvider<BudgetPlan?>((ref) async {
  final user = ref.watch(currentUserProvider);
  final period = ref.watch(activePeriodProvider).valueOrNull;
  if (user == null || period == null) return null;
  return IsarService.getBudgetPlan(userId: user.uid, periodId: period.periodId);
});

// ─── Budget allocations with live spent amounts ───────────────────────────

final budgetAllocationsProvider = FutureProvider<List<BudgetAllocation>>((ref) async {
  final user = ref.watch(currentUserProvider);
  final period = ref.watch(activePeriodProvider).valueOrNull;
  if (user == null || period == null) return [];

  final allocations = await IsarService.getBudgetAllocations(
    userId: user.uid,
    periodId: period.periodId,
  );
  if (allocations.isEmpty) return [];

  // Compute spent amounts live from transactions (accurate even after re-categorisation)
  final categoryTotals = await IsarService.getCategoryTotals(
    userId: user.uid,
    start: period.startDate,
    end: period.endDate,
    creditOnly: false,
  );

  for (final alloc in allocations) {
    alloc.spentAmount = categoryTotals[alloc.categoryId] ?? 0;
  }

  allocations.sort((a, b) => b.usagePercent.compareTo(a.usagePercent));
  return allocations;
});

// ─── Budget setup notifier ────────────────────────────────────────────────

class BudgetSetupState {
  final bool isSaving;
  final String? error;
  final bool saved;
  const BudgetSetupState({this.isSaving = false, this.error, this.saved = false});
}

class BudgetSetupNotifier extends StateNotifier<BudgetSetupState> {
  final Ref _ref;

  BudgetSetupNotifier(this._ref) : super(const BudgetSetupState());

  Future<void> saveBudget({
    required double expectedIncome,
    required Map<TransactionCategoryId, double> categoryPercents,
  }) async {
    final user = _ref.read(currentUserProvider);
    final period = _ref.read(activePeriodProvider).valueOrNull;
    if (user == null || period == null) {
      AppLogger.budget('saveBudget: no user or period — skipping');
      return;
    }

    AppLogger.budget(
      'Saving budget plan: income=Ksh ${expectedIncome.toStringAsFixed(0)} '
      'categories=${categoryPercents.length} period=${period.periodId}',
    );
    state = const BudgetSetupState(isSaving: true);
    try {
      final planId = '${user.uid}_${period.periodId}';
      final plan = BudgetPlan()
        ..planId = planId
        ..userId = user.uid
        ..periodId = period.periodId
        ..expectedIncome = expectedIncome
        ..isFromAiSuggestion = false
        ..isUserConfirmed = true
        ..createdAt = DateTime.now();

      await IsarService.saveBudgetPlan(plan);
      AppLogger.budget('Budget plan saved — planId=$planId');

      // Update period expected income
      period.expectedIncome = expectedIncome;
      await IsarService.savePeriod(period);

      final allocations = categoryPercents.entries.map((e) {
        final a = BudgetAllocation()
          ..userId = user.uid
          ..periodId = period.periodId
          ..categoryId = e.key
          ..allocatedAmount = expectedIncome * (e.value / 100)
          ..allocatedPercent = e.value
          ..spentAmount = 0
          ..alertAt80 = true
          ..alertAt100 = true
          ..alert80Sent = false
          ..alert100Sent = false;
        return a;
      }).toList();

      await IsarService.saveBudgetAllocations(allocations);
      AppLogger.budget('✅ ${allocations.length} budget allocations saved');

      _ref.invalidate(activeBudgetPlanProvider);
      _ref.invalidate(budgetAllocationsProvider);
      _ref.invalidate(activePeriodProvider);

      state = const BudgetSetupState(saved: true);
      AppLogger.budget('✅ Budget setup complete');
    } catch (e, st) {
      AppLogger.error('💰 BUDGET', 'saveBudget failed', e, st);
      state = BudgetSetupState(error: e.toString());
    }
  }
}

final budgetSetupProvider =
    StateNotifierProvider<BudgetSetupNotifier, BudgetSetupState>((ref) {
  return BudgetSetupNotifier(ref);
});
