import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/inherited_strings.dart';
import '../../../core/models/transaction_category.dart';
import '../../../core/theme/app_theme.dart';
import '../../transactions/providers/transactions_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/spending_trend_chart.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb) return;
      final notifier = ref.read(smsImportProvider.notifier);
      notifier.importHistoricalSms();
      notifier.startListening();
    });
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync  = ref.watch(dashboardSummaryProvider);
    final periodAsync   = ref.watch(activePeriodProvider);
    final txnCountAsync = ref.watch(periodTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/logo.jpeg',
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text('FabroCent'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () async {
          ref.invalidate(dashboardSummaryProvider);
          if (!kIsWeb) {
            await ref.read(smsImportProvider.notifier).importHistoricalSms();
          }
        },
        child: summaryAsync.when(
          loading: () => const _DashboardSkeleton(),
          error:   (e, _) => _DashboardError(error: e),
          data:    (summary) {
            final s        = InheritedStrings.of(context);
            final txnCount = txnCountAsync.valueOrNull?.length ?? 0;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Balance card
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: BalanceCard(
                      totalIncome:   summary.totalIncome,
                      totalExpenses: summary.totalExpenses,
                      period:        periodAsync.valueOrNull,
                    ),
                  ),
                ),

                // Quick stats row
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: _QuickStatsRow(
                      savingsRate: summary.savingsRate,
                      txnCount:    txnCount,
                    ),
                  ),
                ),

                // Web notice
                if (kIsWeb)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: const SliverToBoxAdapter(child: _WebNotice()),
                  ),

                // Untagged nudge
                if (summary.untaggedCount > 0)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: _UntaggedNudge(
                        count: summary.untaggedCount,
                        total: summary.untaggedTotal,
                      ),
                    ),
                  ),

                // Spending breakdown
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: _SectionCard(
                      title: s.spendingBreakdown,
                      icon:  Icons.pie_chart_outline_rounded,
                      child: summary.totalExpenses == 0
                          ? _EmptySection(s.noExpensesYet)
                          : CategoryPieChart(data: summary.expenseByCategory),
                    ),
                  ),
                ),

                // Income breakdown
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: _SectionCard(
                      title: s.incomeSources,
                      icon:  Icons.arrow_circle_down_outlined,
                      child: summary.totalIncome == 0
                          ? _EmptySection(s.noIncomeYet)
                          : CategoryPieChart(
                              data:       summary.incomeByCategory,
                              showIncome: true,
                            ),
                    ),
                  ),
                ),

                // Weekly spending trend
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: _SectionCard(
                      title: 'Weekly Trend',
                      icon:  Icons.bar_chart_rounded,
                      child: const SpendingTrendChart(),
                    ),
                  ),
                ),

                // Category totals
                if (summary.expenseByCategory.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: _CategoryList(data: summary.expenseByCategory),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Quick stats row
// ─────────────────────────────────────────────────────────────────────────────

class _QuickStatsRow extends StatelessWidget {
  final double savingsRate;
  final int    txnCount;
  const _QuickStatsRow({required this.savingsRate, required this.txnCount});

  @override
  Widget build(BuildContext context) {
    final positive = savingsRate >= 0;
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon:       Icons.savings_outlined,
            label:      'Savings Rate',
            value:      '${savingsRate.toStringAsFixed(1)}%',
            valueColor: positive ? AppTheme.incomeGreen : AppTheme.expenseRed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            icon:  Icons.receipt_long_outlined,
            label: 'Transactions',
            value: '$txnCount',
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  final Color?   valueColor;
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color:        theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:        theme.colorScheme.onSurface.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: valueColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Web notice banner
// ─────────────────────────────────────────────────────────────────────────────

class _WebNotice extends StatelessWidget {
  const _WebNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color:        theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.phone_android_outlined, color: AppTheme.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'M-Pesa SMS is synced from the mobile app. '
              'Install FabroCent on Android to automatically capture transactions.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Section card with branded icon header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String   title;
  final IconData icon;
  final Widget   child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border:       Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color:        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: theme.textTheme.titleLarge),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Untagged nudge
// ─────────────────────────────────────────────────────────────────────────────

class _UntaggedNudge extends StatelessWidget {
  final int    count;
  final double total;
  const _UntaggedNudge({required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        AppTheme.accentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Text('⚡', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  InheritedStrings.of(context).untaggedNudgeTitle(count),
                  style: theme.textTheme.titleSmall?.copyWith(color: AppTheme.warning),
                ),
                Text(
                  InheritedStrings.of(context).untaggedNudgeSub(_fmt(total)),
                  style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.warning),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.warning),
        ],
      ),
    );
  }

  String _fmt(double v) =>
      v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}K' : v.toStringAsFixed(0);
}

// ─────────────────────────────────────────────────────────────────────────────
//  Category breakdown list
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryList extends StatelessWidget {
  final Map<TransactionCategoryId, double> data;
  const _CategoryList({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s     = InheritedStrings.of(context);
    final total = data.values.fold(0.0, (a, b) => a + b);

    final sorted = data.entries
        .where((e) => e.key != TransactionCategoryId.uncategorized && e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sorted.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color:        theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border:       Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color:        theme.colorScheme.onSurface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.list_alt_rounded, color: AppTheme.primary, size: 16),
                ),
                const SizedBox(width: 10),
                Text(s.allCategories, style: theme.textTheme.titleLarge),
              ],
            ),
          ),
          const Divider(height: 1),
          ...sorted.map((entry) {
            final cat = TransactionCategory.fromId(entry.key);
            final pct = total > 0 ? (entry.value / total) * 100 : 0.0;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Text(cat.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cat.name,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'Ksh ${_fmt(entry.value)}',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color:      AppTheme.expenseRed,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: TweenAnimationBuilder<double>(
                                tween:    Tween(begin: 0, end: pct / 100),
                                duration: const Duration(milliseconds: 700),
                                curve:    Curves.easeOutCubic,
                                builder: (context2, v, child2) => LinearProgressIndicator(
                                  value:           v,
                                  backgroundColor: cat.color.withValues(alpha: 0.12),
                                  color:           cat.color,
                                  minHeight:       5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              s.ofSpending(pct.toStringAsFixed(1)),
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (sorted.last.key != entry.key)
                  const Divider(height: 1, indent: 16),
              ],
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000) {
      final parts = v.toStringAsFixed(2).split('.');
      final buf   = StringBuffer();
      for (var i = 0; i < parts[0].length; i++) {
        if (i > 0 && (parts[0].length - i) % 3 == 0) buf.write(',');
        buf.write(parts[0][i]);
      }
      return '$buf.${parts[1]}';
    }
    return v.toStringAsFixed(2);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Empty section placeholder
// ─────────────────────────────────────────────────────────────────────────────

class _EmptySection extends StatelessWidget {
  final String message;
  const _EmptySection(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size:  40,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Loading skeleton
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final base   = theme.colorScheme.onSurface.withValues(alpha: 0.08);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Balance card skeleton
        Container(
          height: 140,
          decoration: BoxDecoration(
            color:        base,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 12),
        // Quick stats skeleton
        Row(
          children: [
            Expanded(
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color:        base,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color:        base,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color:        base,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color:        base,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 32),
          child: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Error state
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardError extends StatelessWidget {
  final Object error;
  const _DashboardError({required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color:        AppTheme.errorLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.error_outline_rounded, color: AppTheme.error, size: 36),
            ),
            const SizedBox(height: 16),
            Text('Something went wrong', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Could not load your dashboard. Please pull down to try again.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
