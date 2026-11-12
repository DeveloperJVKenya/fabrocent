import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final periodAsync = ref.watch(activePeriodProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.jpeg',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'FabroCent',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.3),
            ),
          ],
        ),
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (summary) {
            final s = InheritedStrings.of(context);
            return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: BalanceCard(
                    totalIncome: summary.totalIncome,
                    totalExpenses: summary.totalExpenses,
                    period: periodAsync.valueOrNull,
                  ),
                ),
              ),

              // Untagged nudge
              if (summary.untaggedCount > 0)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                    child: summary.totalExpenses == 0
                        ? _EmptySection(s.noExpensesYet)
                        : CategoryPieChart(
                            data: summary.expenseByCategory,
                          ),
                  ),
                ),
              ),

              // Income breakdown
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: _SectionCard(
                    title: s.incomeSources,
                    child: summary.totalIncome == 0
                        ? _EmptySection(s.noIncomeYet)
                        : CategoryPieChart(
                            data: summary.incomeByCategory,
                            showIncome: true,
                          ),
                  ),
                ),
              ),

              // Weekly spending trend
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                sliver: const SliverToBoxAdapter(
                  child: SpendingTrendChart(),
                ),
              ),

              // Category totals list
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _UntaggedNudge extends StatelessWidget {
  final int count;
  final double total;

  const _UntaggedNudge({required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Text('âš¡', style: TextStyle(fontSize: 18)),
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

  String _fmt(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

class _CategoryList extends StatelessWidget {
  final Map<TransactionCategoryId, double> data;

  const _CategoryList({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = InheritedStrings.of(context);
    final total = data.values.fold(0.0, (a, b) => a + b);

    final sorted = data.entries
        .where((e) => e.key != TransactionCategoryId.uncategorized && e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sorted.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(s.allCategories, style: theme.textTheme.titleLarge),
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
                      Text(cat.emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(cat.name, style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                )),
                                Text(
                                  'Ksh ${_fmt(entry.value)}',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: AppTheme.expenseRed,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: pct / 100,
                                backgroundColor: cat.color.withValues(alpha: 0.1),
                                color: cat.color,
                                minHeight: 4,
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
                if (sorted.last.key != entry.key) const Divider(height: 1, indent: 16),
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
      final buf = StringBuffer();
      for (var i = 0; i < parts[0].length; i++) {
        if (i > 0 && (parts[0].length - i) % 3 == 0) buf.write(',');
        buf.write(parts[0][i]);
      }
      return '$buf.${parts[1]}';
    }
    return v.toStringAsFixed(2);
  }
}

class _EmptySection extends StatelessWidget {
  final String message;
  const _EmptySection(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(message, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
