import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/inherited_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';

class SpendingTrendChart extends ConsumerWidget {
  const SpendingTrendChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAsync = ref.watch(weeklySpendingProvider);
    final theme = Theme.of(context);

    return weeklyAsync.when(
      loading: () => const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (weeks) {
        if (weeks.isEmpty || weeks.every((w) => w.amount == 0)) {
          return const SizedBox.shrink();
        }

        final maxY = weeks.map((w) => w.amount).reduce(max);

        final s = InheritedStrings.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.weeklySpending, style: theme.textTheme.titleLarge),
            const SizedBox(height: 14),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  maxY: maxY * 1.25,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) =>
                          theme.cardColor.withValues(alpha: 0.95),
                      getTooltipItem: (group, _, rod, _) {
                        final w = weeks[group.x];
                        return BarTooltipItem(
                          '${w.label}\nKsh ${_fmt(rod.toY)}',
                          theme.textTheme.labelMedium!,
                        );
                      },
                    ),
                  ),
                  barGroups: weeks.asMap().entries.map((e) {
                    final isHighest =
                        e.value.amount == maxY && e.value.amount > 0;
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.amount,
                          color: isHighest
                              ? AppTheme.expenseRed
                              : AppTheme.primary,
                          width: 28,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6)),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxY * 1.25,
                            color: AppTheme.primary.withValues(alpha: 0.06),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (value, _) {
                          final i = value.toInt();
                          if (i < 0 || i >= weeks.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              weeks[i].label,
                              style: theme.textTheme.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _fmt(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}
