import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';
import '../../../core/models/transaction_category.dart';
import '../../../core/theme/app_theme.dart';

class CategoryPieChart extends StatefulWidget {
  final Map<TransactionCategoryId, double> data;
  final bool showIncome;

  const CategoryPieChart({
    super.key,
    required this.data,
    this.showIncome = false,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter and sort top categories (exclude uncategorized from chart)
    final filtered = widget.data.entries
        .where((e) => e.key != TransactionCategoryId.uncategorized && e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top = filtered.take(6).toList();
    if (top.isEmpty) {
      return _EmptyChart(message: widget.showIncome ? 'No income recorded' : 'No expenses recorded');
    }

    final total = top.fold(0.0, (s, e) => s + e.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 46,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedIndex = null;
                          return;
                        }
                        _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sections: List.generate(top.length, (i) {
                    final entry = top[i];
                    final cat = TransactionCategory.fromId(entry.key);
                    final pct = (entry.value / total) * 100;
                    final isTouched = i == _touchedIndex;
                    return PieChartSectionData(
                      color: cat.color,
                      value: entry.value,
                      title: isTouched ? '${pct.toStringAsFixed(1)}%' : '',
                      radius: isTouched ? 54 : 48,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      badgeWidget: isTouched ? null : null,
                    );
                  }),
                  centerSpaceColor: theme.scaffoldBackgroundColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: top.map((entry) {
                  final cat = TransactionCategory.fromId(entry.key);
                  final pct = (entry.value / total) * 100;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: cat.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cat.name,
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${pct.toStringAsFixed(0)}%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cat.color,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyChart extends StatelessWidget {
  final String message;
  const _EmptyChart({required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart_rounded, color: AppTheme.primary, size: 32),
            const SizedBox(height: 8),
            Text(message, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
