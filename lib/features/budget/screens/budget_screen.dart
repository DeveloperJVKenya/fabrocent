import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/inherited_strings.dart';
import '../../../core/models/budget.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/budget_provider.dart';
import '../../transactions/providers/transactions_provider.dart';
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
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primary),
        ),
        error: (e, _) => _BudgetError(error: e),
        data: (plan) {
          if (kIsWeb) return const _WebBudgetNotice();

          if (plan == null) {
            return _EmptyBudget(onSetUp: () => _openSetup(context));
          }

          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: () async {
              ref.invalidate(budgetAllocationsProvider);
              ref.invalidate(activeBudgetPlanProvider);
              ref.invalidate(activePeriodProvider);
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
                        child: Text(
                          InheritedStrings.of(context).noAllocations,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          InheritedStrings.of(context).spendingLimits,
                          style: theme.textTheme.titleLarge,
                        ),
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

// ─── Web notice (budget is native-only) ──────────────────────────────────────

class _WebBudgetNotice extends StatelessWidget {
  const _WebBudgetNotice();

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
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color:  theme.colorScheme.onSurface.withValues(alpha: 0.08),
                shape:  BoxShape.circle,
              ),
              child: const Icon(
                Icons.phone_android_rounded,
                color: AppTheme.primary,
                size:  44,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Budget on Mobile',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Set spending limits and get real-time overspend alerts in the '
              'FabroCent Android app. Download it to unlock the full budget experience.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color:        theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline, color: AppTheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Your data syncs automatically once installed',
                    style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Budget load error ────────────────────────────────────────────────────────

class _BudgetError extends StatelessWidget {
  final Object error;
  const _BudgetError({required this.error});

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
            Text('Could not load budget', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Please restart the app or pull down to refresh.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ─────────────────────────────────────────────────────────────

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
            Text(
              InheritedStrings.of(context).setBudgetTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
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

// ─── Income summary card ─────────────────────────────────────────────────────

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
                Text(
                  InheritedStrings.of(context).expectedMonthlyIncome,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ksh ${_fmt(expectedIncome)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.white70,
            size: 36,
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

// ─── Allocation card ─────────────────────────────────────────────────────────

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.expenseRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    s.over,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.expenseRed,
                    ),
                  ),
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
                    ? s.budgetOverBy(
                        _fmt(
                          allocation.spentAmount - allocation.allocatedAmount,
                        ),
                      )
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
            s.budgetLine(
              _fmt(allocation.allocatedAmount),
              allocation.allocatedPercent.toStringAsFixed(0),
            ),
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
