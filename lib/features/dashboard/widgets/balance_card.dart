import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/inherited_strings.dart';
import '../../../core/models/financial_period.dart';
import '../../../core/theme/app_theme.dart';

class BalanceCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpenses;
  final FinancialPeriod? period;

  const BalanceCard({
    super.key,
    required this.totalIncome,
    required this.totalExpenses,
    this.period,
  });

  @override
  Widget build(BuildContext context) {
    final s = InheritedStrings.of(context);
    final net = totalIncome - totalExpenses;
    final isPositive = net >= 0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, AppTheme.primaryLight],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                period?.displayName ?? s.thisMonth,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isPositive ? s.surplus : s.deficit,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            s.netBalance,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            _formatKes(net.abs()),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: s.income,
                  value: totalIncome,
                  icon: Icons.arrow_downward_rounded,
                  iconColor: const Color(0xFF80FF9F),
                ),
              ),
              Container(width: 1, height: 36, color: Colors.white24),
              Expanded(
                child: _StatItem(
                  label: s.expenses,
                  value: totalExpenses,
                  icon: Icons.arrow_upward_rounded,
                  iconColor: const Color(0xFFFF9B9B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatKes(double amount) {
    if (amount >= 1000000)
      return 'Ksh ${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) {
      final parts = amount.toStringAsFixed(2).split('.');
      final intPart = parts[0];
      final buf = StringBuffer();
      for (var i = 0; i < intPart.length; i++) {
        if (i > 0 && (intPart.length - i) % 3 == 0) buf.write(',');
        buf.write(intPart[i]);
      }
      return 'Ksh $buf.${parts[1]}';
    }
    return 'Ksh ${amount.toStringAsFixed(2)}';
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color iconColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
                Text(
                  _fmt(value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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

  String _fmt(double v) {
    if (v >= 1000) return 'Ksh ${(v / 1000).toStringAsFixed(1)}K';
    return 'Ksh ${v.toStringAsFixed(0)}';
  }
}
