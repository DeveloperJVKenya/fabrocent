import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/transaction_category.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/budget_provider.dart';

class BudgetSetupScreen extends ConsumerStatefulWidget {
  const BudgetSetupScreen({super.key});

  @override
  ConsumerState<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends ConsumerState<BudgetSetupScreen> {
  final _incomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<TransactionCategoryId, double> _percents = {};
  int _page = 0;

  double get _totalPercent =>
      _percents.values.fold(0.0, (a, b) => a + b);

  double get _expectedIncome =>
      double.tryParse(_incomeController.text.replaceAll(',', '')) ?? 0;

  @override
  void initState() {
    super.initState();
    // Default allocations
    _percents[TransactionCategoryId.foodGroceries] = 25;
    _percents[TransactionCategoryId.transport] = 10;
    _percents[TransactionCategoryId.housing] = 30;
    _percents[TransactionCategoryId.utilities] = 5;
    _percents[TransactionCategoryId.health] = 5;
    _percents[TransactionCategoryId.education] = 5;
    _percents[TransactionCategoryId.savings] = 10;
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == 0) {
      if (!_formKey.currentState!.validate()) return;
      setState(() => _page = 1);
    } else {
      _save();
    }
  }

  Future<void> _save() async {
    if (_totalPercent == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Set at least one budget allocation.')),
      );
      return;
    }

    final filtered = Map.fromEntries(
      _percents.entries.where((e) => e.value > 0),
    );

    await ref.read(budgetSetupProvider.notifier).saveBudget(
          expectedIncome: _expectedIncome,
          categoryPercents: filtered,
        );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final saving = ref.watch(budgetSetupProvider).isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(_page == 0 ? 'Expected Income' : 'Allocate Budget'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_page == 1) {
              setState(() => _page = 0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Progress dots
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppTheme.primary : theme.dividerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

          Expanded(
            child: _page == 0
                ? _IncomeStep(
                    formKey: _formKey,
                    controller: _incomeController,
                  )
                : _AllocationStep(
                    percents: _percents,
                    totalPercent: _totalPercent,
                    expectedIncome: _expectedIncome,
                    onChanged: (id, v) => setState(() => _percents[id] = v),
                  ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 8, 16, MediaQuery.paddingOf(context).bottom + 16),
            child: ElevatedButton(
              onPressed: saving ? null : _next,
              child: saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(_page == 0 ? 'Next' : 'Save Budget'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 1 — expected income ─────────────────────────────────────────────────

class _IncomeStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

  const _IncomeStep({required this.formKey, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What is your expected\nmonthly income?',
                style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Include salary, business income, side hustles — everything.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            TextFormField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Monthly Income (Ksh)',
                prefixText: 'Ksh ',
                hintText: '50,000',
              ),
              validator: (v) {
                final n = double.tryParse((v ?? '').replaceAll(',', ''));
                if (n == null || n <= 0) return 'Enter a valid income amount';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppTheme.primary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your income stays on-device and is never shared.',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppTheme.primary),
                    ),
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

// ─── Step 2 — category allocation ─────────────────────────────────────────────

class _AllocationStep extends StatelessWidget {
  final Map<TransactionCategoryId, double> percents;
  final double totalPercent;
  final double expectedIncome;
  final void Function(TransactionCategoryId, double) onChanged;

  const _AllocationStep({
    required this.percents,
    required this.totalPercent,
    required this.expectedIncome,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = (100 - totalPercent).clamp(0.0, 100.0);
    final isOver = totalPercent > 100;
    final categories = TransactionCategory.expenseCategories;

    return Column(
      children: [
        // Total bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isOver
                  ? AppTheme.errorLight
                  : AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOver
                            ? 'Over-allocated by ${(totalPercent - 100).toStringAsFixed(0)}%'
                            : '${remaining.toStringAsFixed(0)}% unallocated',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: isOver ? AppTheme.error : AppTheme.primary,
                        ),
                      ),
                      Text(
                        'Total: ${totalPercent.toStringAsFixed(0)}% of Ksh ${_fmt(expectedIncome)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isOver ? AppTheme.error : AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isOver ? Icons.warning_amber_rounded : Icons.pie_chart_outline,
                  color: isOver ? AppTheme.error : AppTheme.primary,
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(height: 2),
            itemBuilder: (_, i) {
              final cat = categories[i];
              final pct = percents[cat.id] ?? 0.0;
              final kshAmount = expectedIncome * (pct / 100);

              return _CategorySliderRow(
                category: cat,
                percent: pct,
                kshAmount: kshAmount,
                onChanged: (v) => onChanged(cat.id, v),
              );
            },
          ),
        ),
      ],
    );
  }

  String _fmt(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

class _CategorySliderRow extends StatelessWidget {
  final TransactionCategory category;
  final double percent;
  final double kshAmount;
  final ValueChanged<double> onChanged;

  const _CategorySliderRow({
    required this.category,
    required this.percent,
    required this.kshAmount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(category.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(category.name, style: theme.textTheme.titleSmall),
                    Text(
                      '${percent.toStringAsFixed(0)}%'
                      '${kshAmount > 0 ? '  Â·  Ksh ${_fmt(kshAmount)}' : ''}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: percent > 0 ? category.color : null,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: category.color,
                    thumbColor: category.color,
                    inactiveTrackColor: category.color.withValues(alpha: 0.15),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                  ),
                  child: Slider(
                    value: percent,
                    min: 0,
                    max: 50,
                    divisions: 50,
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
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
