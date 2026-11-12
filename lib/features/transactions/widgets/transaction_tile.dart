import 'package:material_ui/material_ui.dart';
import '../../../core/models/transaction.dart';
import '../../../core/theme/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cat = transaction.category;
    final isCredit = transaction.isCredit;
    final isUntagged = transaction.isUntagged;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: isUntagged
              ? Border.all(color: AppTheme.accent.withValues(alpha: 0.5), width: 1.5)
              : Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            // Category icon circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cat.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isUntagged
                    ? const Icon(Icons.help_outline_rounded, color: AppTheme.accent, size: 22)
                    : Text(cat.emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.displayCounterparty,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        transaction.formattedAmount,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isCredit ? AppTheme.incomeGreen : AppTheme.expenseRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        isUntagged ? 'Tap to categorise' : cat.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isUntagged ? AppTheme.warning : null,
                          fontWeight: isUntagged ? FontWeight.w600 : null,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(transaction.dateTime),
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                  if (transaction.isPochi) ...[
                    const SizedBox(height: 3),
                    _PochiBadge(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt).inDays;
    if (diff == 0) return _time(dt);
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return _weekday(dt);
    return '${dt.day}/${dt.month}';
  }

  String _time(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  String _weekday(DateTime dt) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dt.weekday - 1];
  }
}

class _PochiBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.accentLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Pochi la Biashara',
        style: TextStyle(
          color: AppTheme.warning,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
