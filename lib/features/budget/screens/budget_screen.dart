import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/inherited_strings.dart';
import '../../../core/models/budget.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/budget_provider.dart';
import 'budget_setup_screen.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(activeBudgetPlanProvider);
    final allocationsAsync = ref.watch(budgetAllocationsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(InheritedStrings.of(context).budgetTitle),
        actions: [
          planAsync.valueOrNull != null
              ? IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: InheritedStrings.of(context).editBudget,
                  onPressed: () => _openSetup(context),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: planAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (plan) {
          if (plan == null) {
            return _EmptyBudget(onSetUp: () => _openSetup(context));
          }

          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () async {
              ref.invalidate(budgetAllocationsProvider);
              ref.invalidate(activeBudgetPlanProvider);
            },
            child: allocationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (allocations) => CustomScrollView(
                slivers: [
                  // Income header
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: _IncomeCard(expectedIncome: plan.expectedIncome),
                    ),
                  ),

                  if (allocations.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(InheritedStrings.of(context).noAllocations,
                            style: theme.textTheme.bodySmall),
                      ),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      sliver: SliverToBoxAdapter(
                        child: Text(InheritedStrings.of(context).spendingLimits,
                            style: theme.textTheme.titleLarge),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _AllocationCard(allocation: allocations[i]),
                          ),
                          childCount: allocations.length,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openSetup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BudgetSetupScreen()),
    );
  }
}

// â”€â”€â”€ Empty state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _EmptyBudget extends StatelessWidget {
  final VoidCallback onSetUp;
  const _EmptyBudget({required this.onSetUp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('💰', style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(InheritedStrings.of(context).setBudgetTitle,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              InheritedStrings.of(context).setBudgetSubtitle,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: onSetUp,
              child: Text(InheritedStrings.of(context).setUpBudget),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Income summary card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _IncomeCard extends StatelessWidget {
  final double expectedIncome;
  const _IncomeCard({required this.expectedIncome});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(InheritedStrings.of(context).expectedMonthlyIncome,
                    style: theme.textTheme.labelMedium
                        ?.copyWith(color: Colors.white70)),
                const SizedBox(height: 4),
                Text(
                  'Ksh ${_fmt(expectedIncome)}',
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const Icon(Icons.account_balance_wallet_outlined,
              color: Colors.white70, size: 36),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

// â”€â”€â”€ Allocation card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _AllocationCard extends StatelessWidget {
  final BudgetAllocation allocation;
  const _AllocationCard({required this.allocation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = InheritedStrings.of(context);
    final cat = allocation.category;
    final usage = allocation.usagePercent.clamp(0.0, 100.0) / 100.0;
    final isOver = allocation.isOverBudget;
    final isWarning = !isOver && allocation.usagePercent >= 80;

    final barColor = isOver
        ? AppTheme.expenseRed
        : isWarning
            ? AppTheme.warning
            : cat.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOver
              ? AppTheme.expenseRed.withValues(alpha: 0.4)
              : theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(cat.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(cat.name, style: theme.textTheme.titleMedium),
              ),
              if (isOver)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.expenseRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(s.over,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: AppTheme.expenseRed)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usage,
              backgroundColor: barColor.withValues(alpha: 0.12),
              color: barColor,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.budgetSpent(_fmt(allocation.spentAmount)),
                style: theme.textTheme.bodySmall,
              ),
              Text(
                isOver
                    ? s.budgetOverBy(_fmt(allocation.spentAmount - allocation.allocatedAmount))
                    : s.budgetLeft(_fmt(allocation.remainingAmount)),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isOver ? AppTheme.expenseRed : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            s.budgetLine(_fmt(allocation.allocatedAmount),
                allocation.allocatedPercent.toStringAsFixed(0)),
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}
