import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/isar_service.dart';
import '../../../core/models/transaction.dart';
import '../../../core/models/transaction_category.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/web_data_providers.dart';
import '../../../core/services/app_logger.dart';
import '../../transactions/providers/transactions_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  DashboardSummary model
// ─────────────────────────────────────────────────────────────────────────────

class DashboardSummary {
  final double totalIncome;
  final double totalExpenses;
  final Map<TransactionCategoryId, double> expenseByCategory;
  final Map<TransactionCategoryId, double> incomeByCategory;
  final double untaggedTotal;
  final int untaggedCount;

  const DashboardSummary({
    required this.totalIncome,
    required this.totalExpenses,
    required this.expenseByCategory,
    required this.incomeByCategory,
    required this.untaggedTotal,
    required this.untaggedCount,
  });

  double get netBalance  => totalIncome - totalExpenses;
  double get savingsRate =>
      totalIncome > 0 ? ((totalIncome - totalExpenses) / totalIncome) * 100 : 0;

  static const DashboardSummary empty = DashboardSummary(
    totalIncome: 0,
    totalExpenses: 0,
    expenseByCategory: {},
    incomeByCategory: {},
    untaggedTotal: 0,
    untaggedCount: 0,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  Web helper — compute summary from Firestore transaction list (no Isar)
// ─────────────────────────────────────────────────────────────────────────────

DashboardSummary _summaryFromTransactions(List<Transaction> txns) {
  final expenseByCategory = <TransactionCategoryId, double>{};
  final incomeByCategory  = <TransactionCategoryId, double>{};

  for (final txn in txns) {
    if (txn.isCredit) {
      incomeByCategory[txn.categoryId] =
          (incomeByCategory[txn.categoryId] ?? 0) + txn.amount;
    } else {
      expenseByCategory[txn.categoryId] =
          (expenseByCategory[txn.categoryId] ?? 0) + txn.amount;
    }
  }

  final totalIncome   = incomeByCategory.values.fold(0.0, (a, b) => a + b);
  final totalExpenses = expenseByCategory.values.fold(0.0, (a, b) => a + b);
  final untaggedExpenses = expenseByCategory[TransactionCategoryId.uncategorized] ?? 0;
  final untaggedIncome   = incomeByCategory[TransactionCategoryId.uncategorized]  ?? 0;
  final untaggedCount    = txns
      .where((t) => t.categoryId == TransactionCategoryId.uncategorized)
      .length;

  AppLogger.dash(
    '✅ Dashboard summary [web]: income=Ksh ${totalIncome.toStringAsFixed(0)} '
    'expenses=Ksh ${totalExpenses.toStringAsFixed(0)} '
    'untagged=$untaggedCount',
  );

  return DashboardSummary(
    totalIncome:        totalIncome,
    totalExpenses:      totalExpenses,
    expenseByCategory:  expenseByCategory,
    incomeByCategory:   incomeByCategory,
    untaggedTotal:      untaggedExpenses + untaggedIncome,
    untaggedCount:      untaggedCount,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  Providers
// ─────────────────────────────────────────────────────────────────────────────

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    AppLogger.dash('dashboardSummary: no user — returning empty');
    return DashboardSummary.empty;
  }

  if (kIsWeb) {
    // Web: Isar not available — compute from Firestore stream.
    final txns = ref.watch(webTransactionsProvider).valueOrNull ?? [];
    AppLogger.dash('dashboardSummary [web]: ${txns.length} Firestore transactions');
    return _summaryFromTransactions(txns);
  }

  final period = await ref.watch(activePeriodProvider.future);
  if (period == null) {
    AppLogger.dash('dashboardSummary: no period — returning empty');
    return DashboardSummary.empty;
  }

  AppLogger.dash('Computing dashboard summary for period ${period.periodId}');

  final expenseByCategory = await IsarService.getCategoryTotals(
    userId:    user.uid,
    start:     period.startDate,
    end:       period.endDate,
    creditOnly: false,
  );
  final incomeByCategory = await IsarService.getCategoryTotals(
    userId:    user.uid,
    start:     period.startDate,
    end:       period.endDate,
    creditOnly: true,
  );

  final totalExpenses = expenseByCategory.values.fold(0.0, (a, b) => a + b);
  final totalIncome   = incomeByCategory.values.fold(0.0, (a, b) => a + b);
  final untaggedExpenses = expenseByCategory[TransactionCategoryId.uncategorized] ?? 0;
  final untaggedIncome   = incomeByCategory[TransactionCategoryId.uncategorized]  ?? 0;
  final untaggedCount = await ref.watch(untaggedCountProvider.future);

  AppLogger.dash(
    '✅ Dashboard summary: income=Ksh ${totalIncome.toStringAsFixed(0)} '
    'expenses=Ksh ${totalExpenses.toStringAsFixed(0)} '
    'net=Ksh ${(totalIncome - totalExpenses).toStringAsFixed(0)} '
    'untagged=$untaggedCount',
  );

  return DashboardSummary(
    totalIncome:        totalIncome,
    totalExpenses:      totalExpenses,
    expenseByCategory:  expenseByCategory,
    incomeByCategory:   incomeByCategory,
    untaggedTotal:      untaggedExpenses + untaggedIncome,
    untaggedCount:      untaggedCount,
  );
});

// ─── Balance timeline ─────────────────────────────────────────────────────────

class BalancePoint {
  final DateTime date;
  final double   balance;
  const BalancePoint(this.date, this.balance);
}

final balanceTimelineProvider = Provider<List<BalancePoint>>((ref) {
  final transactionsAsync = ref.watch(periodTransactionsProvider);
  return transactionsAsync.valueOrNull
          ?.where((t) => t.balanceAfter != null)
          .map((t) => BalancePoint(t.dateTime, t.balanceAfter!))
          .toList()
          .reversed
          .toList() ??
      [];
});

// ─── Weekly spending for bar chart ───────────────────────────────────────────

class WeeklySpending {
  final String label;
  final double amount;
  const WeeklySpending(this.label, this.amount);
}

List<WeeklySpending> _weeklyFromTransactions(List<Transaction> txns) {
  final weeklyMap = <int, double>{};
  for (final txn in txns) {
    if (txn.isCredit) continue;
    if (txn.categoryId == TransactionCategoryId.uncategorized) continue;
    final week = ((txn.dateTime.day - 1) ~/ 7) + 1;
    weeklyMap[week] = (weeklyMap[week] ?? 0) + txn.amount;
  }
  if (weeklyMap.isEmpty) return [];
  final now      = DateTime.now();
  final lastDay  = DateTime(now.year, now.month + 1, 0).day;
  final totalWeeks = ((lastDay - 1) ~/ 7) + 1;
  return List.generate(
    totalWeeks,
    (i) => WeeklySpending('Wk ${i + 1}', weeklyMap[i + 1] ?? 0),
  );
}

final weeklySpendingProvider = FutureProvider<List<WeeklySpending>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  if (kIsWeb) {
    final txns = ref.watch(webTransactionsProvider).valueOrNull ?? [];
    return _weeklyFromTransactions(txns);
  }

  final period = await ref.watch(activePeriodProvider.future);
  if (period == null) return [];

  final txns = await IsarService.getTransactionsForPeriod(
    userId: user.uid,
    start:  period.startDate,
    end:    period.endDate,
  );

  final weeklyMap = <int, double>{};
  for (final txn in txns) {
    if (txn.isCredit) continue;
    if (txn.categoryId == TransactionCategoryId.uncategorized) continue;
    final week = ((txn.dateTime.day - 1) ~/ 7) + 1;
    weeklyMap[week] = (weeklyMap[week] ?? 0) + txn.amount;
  }

  if (weeklyMap.isEmpty) return [];

  final totalWeeks = ((period.endDate.day - 1) ~/ 7) + 1;
  return List.generate(
    totalWeeks,
    (i) => WeeklySpending('Wk ${i + 1}', weeklyMap[i + 1] ?? 0),
  );
});
