import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/inherited_strings.dart';
import '../../../core/models/transaction.dart';
import '../../../core/models/transaction_category.dart';
import '../../../core/models/user_profile.dart' show AppLanguage;
import '../../../core/services/ai_categorization_service.dart';
import '../../../core/sms/transaction_type.dart';
import '../../../core/theme/app_theme.dart';
import '../../budget/providers/budget_provider.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../providers/transactions_provider.dart';

class CategoryTagSheet extends ConsumerStatefulWidget {
  final Transaction transaction;

  const CategoryTagSheet({super.key, required this.transaction});

  static Future<void> show(BuildContext context, Transaction txn) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryTagSheet(transaction: txn),
    );
  }

  @override
  ConsumerState<CategoryTagSheet> createState() => _CategoryTagSheetState();
}

class _CategoryTagSheetState extends ConsumerState<CategoryTagSheet> {
  TransactionCategoryId? _selected;
  late Future<TransactionCategoryId?> _aiSuggestion;

  @override
  void initState() {
    super.initState();
    _selected = widget.transaction.isUntagged ? null : widget.transaction.categoryId;
    _aiSuggestion = widget.transaction.isUntagged
        ? AiCategorizationService.suggestCategory(widget.transaction)
        : Future.value(null);
  }

  Future<void> _confirm() async {
    if (_selected == null) return;
    await ref.read(categoryUpdateProvider.notifier).updateCategory(
      transactionId: widget.transaction.id,
      categoryId: _selected!,
    );
    // Refresh both dashboard totals and budget spent
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(budgetAllocationsProvider);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = InheritedStrings.of(context);
    final isCredit = widget.transaction.isCredit;
    final categories = isCredit
        ? TransactionCategory.incomeCategories
        : TransactionCategory.expenseCategories;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Transaction summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.language == AppLanguage.swahili
                                ? widget.transaction.type.swahiliName
                                : widget.transaction.type.displayName,
                            style: theme.textTheme.labelMedium,
                          ),
                          Text(
                            widget.transaction.displayCounterparty,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.transaction.formattedAmount,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: isCredit ? AppTheme.incomeGreen : AppTheme.expenseRed,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(s.selectCategory, style: theme.textTheme.titleLarge),
            ),

            // Category grid
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  // AI suggestion row
                  if (widget.transaction.isUntagged)
                    FutureBuilder<TransactionCategoryId?>(
                      future: _aiSuggestion,
                      builder: (ctx, snap) {
                        if (!snap.hasData || snap.data == null) {
                          return const SizedBox.shrink();
                        }
                        final aiCat = TransactionCategory.fromId(snap.data!);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => setState(() => _selected = aiCat.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: _selected == aiCat.id
                                    ? aiCat.color.withValues(alpha: 0.15)
                                    : AppTheme.primaryContainer.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selected == aiCat.id
                                      ? aiCat.color
                                      : AppTheme.primary.withValues(alpha: 0.3),
                                  width: _selected == aiCat.id ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('âœ¨',
                                      style: TextStyle(fontSize: 14)),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${s.aiSuggests}: ',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(aiCat.emoji,
                                      style: const TextStyle(fontSize: 15)),
                                  const SizedBox(width: 4),
                                  Text(
                                    aiCat.name,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: _selected == aiCat.id
                                          ? aiCat.color
                                          : AppTheme.primary,
                                    ),
                                  ),
                                  if (_selected == aiCat.id) ...[
                                    const SizedBox(width: 4),
                                    Icon(Icons.check,
                                        size: 14, color: aiCat.color),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((cat) {
                      final isSelected = _selected == cat.id;
                      return GestureDetector(
                        onTap: () => setState(() => _selected = cat.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? cat.color.withValues(alpha: 0.15)
                                : theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? cat.color : theme.dividerColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(cat.emoji,
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(
                                cat.name,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: isSelected ? cat.color : null,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 4),
                                Icon(Icons.check, size: 14, color: cat.color),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Confirm button
            Padding(
              padding: EdgeInsets.fromLTRB(
                16, 8, 16, MediaQuery.paddingOf(context).bottom + 16,
              ),
              child: ElevatedButton(
                onPressed: _selected == null ? null : _confirm,
                child: Text(
                  _selected == null ? s.selectCategoryFirst : s.confirmCategory,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
