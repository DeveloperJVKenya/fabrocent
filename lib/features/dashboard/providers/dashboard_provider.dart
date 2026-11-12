import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/models/transaction_category.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/services/app_logger.dart';
import '../../transactions/providers/transactions_provider.dart';

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

  double get netBalance => totalIncome - totalExpenses;

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

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  final user = ref.watch(currentUserProvider);
  final period = await ref.watch(activePeriodProvider.future);

  if (user == null || period == null) {
    AppLogger.dash('dashboardSummary: no user or period — returning empty');
    return DashboardSummary.empty;
  }

  AppLogger.dash('Computing dashboard summary for period ${period.periodId}');

  final expenseByCategory = await IsarService.getCategoryTotals(
    userId: user.uid,
    start: period.startDate,
    end: period.endDate,
    creditOnly: false,
  );

  final incomeByCategory = await IsarService.getCategoryTotals(
    userId: user.uid,
    start: period.startDate,
    end: period.endDate,
    creditOnly: true,
  );

  final totalExpenses = expenseByCategory.values.fold(0.0, (a, b) => a + b);
  final totalIncome = incomeByCategory.values.fold(0.0, (a, b) => a + b);

  // Untagged stats
  final untaggedExpenses = expenseByCategory[TransactionCategoryId.uncategorized] ?? 0;
  final untaggedIncome = incomeByCategory[TransactionCategoryId.uncategorized] ?? 0;
  final untaggedTotal = untaggedExpenses + untaggedIncome;
  final untaggedCount = await ref.watch(untaggedCountProvider.future);

  AppLogger.dash(
    '✅ Dashboard summary: income=Ksh ${totalIncome.toStringAsFixed(0)} '
    'expenses=Ksh ${totalExpenses.toStringAsFixed(0)} '
    'net=Ksh ${(totalIncome - totalExpenses).toStringAsFixed(0)} '
    'untagged=$untaggedCount',
  );

  return DashboardSummary(
    totalIncome: totalIncome,
    totalExpenses: totalExpenses,
    expenseByCategory: expenseByCategory,
    incomeByCategory: incomeByCategory,
    untaggedTotal: untaggedTotal,
    untaggedCount: untaggedCount,
  );
});

// Balance timeline from SMS balance snapshots
class BalancePoint {
  final DateTime date;
  final double balance;
  const BalancePoint(this.date, this.balance);
}

final balanceTimelineProvider = Provider<List<BalancePoint>>((ref) {
  final transactionsAsync = ref.watch(periodTransactionsProvider);
  return transactionsAsync.valueOrNull?.where((t) => t.balanceAfter != null).map((t) {
    return BalancePoint(t.dateTime, t.balanceAfter!);
  }).toList().reversed.toList() ?? [];
});

// ─── Weekly spending for bar chart ───────────────────────────────────────────

class WeeklySpending {
  final String label;
  final double amount;
  const WeeklySpending(this.label, this.amount);
}

final weeklySpendingProvider = FutureProvider<List<WeeklySpending>>((ref) async {
  final user = ref.watch(currentUserProvider);
  final period = await ref.watch(activePeriodProvider.future);
  if (user == null || period == null) return [];

  final txns = await IsarService.getTransactionsForPeriod(
    userId: user.uid,
    start: period.startDate,
    end: period.endDate,
  );

  // Bucket by week-of-month (1-indexed)
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
