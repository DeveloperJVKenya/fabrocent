import 'package:isar_community/isar.dart';

part 'financial_period.g.dart';

@Collection()
class FinancialPeriod {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String periodId; // e.g. "2026-11"

  late DateTime startDate;
  late DateTime endDate;

  late double? expectedIncome; // User's expected income for this period
  late double totalIncome;     // Actual income summed from transactions
  late double totalExpenses;   // Actual expenses summed

  late bool isClosed; // period has ended
  late bool isActive; // current period

  @Index()
  late String userId;

  @ignore
  double get netBalance => totalIncome - totalExpenses;

  @ignore
  String get displayName {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[startDate.month - 1]} ${startDate.year}';
  }

  static String idForDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  static FinancialPeriod forMonth(DateTime date, String userId) {
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
    return FinancialPeriod()
      ..periodId = idForDate(date)
      ..startDate = start
      ..endDate = end
      ..expectedIncome = null
      ..totalIncome = 0
      ..totalExpenses = 0
      ..isClosed = false
      ..isActive = true
      ..userId = userId;
  }
}
