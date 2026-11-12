import 'package:isar_community/isar.dart';
import 'transaction_category.dart';

part 'budget.g.dart';

@Collection()
class BudgetAllocation {
  Id id = Isar.autoIncrement;

  @Index()
  late String userId;

  @Index()
  late String periodId; // which period this budget applies to

  @Enumerated(EnumType.ordinal)
  late TransactionCategoryId categoryId;

  late double allocatedAmount;    // Ksh amount budgeted
  late double allocatedPercent;   // % of expected income
  late double spentAmount;        // running total spent this period
  late bool alertAt80;            // send alert at 80% usage
  late bool alertAt100;           // send alert at 100% usage
  late bool alert80Sent;
  late bool alert100Sent;

  @ignore
  double get remainingAmount => allocatedAmount - spentAmount;

  @ignore
  double get usagePercent =>
      allocatedAmount > 0 ? (spentAmount / allocatedAmount) * 100 : 0;

  @ignore
  bool get isOverBudget => spentAmount > allocatedAmount;

  @ignore
  TransactionCategory get category => TransactionCategory.fromId(categoryId);
}

@Collection()
class BudgetPlan {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String planId; // userId + periodId

  @Index()
  late String userId;

  late String periodId;
  late double expectedIncome;
  late bool isFromAiSuggestion;
  late bool isUserConfirmed;
  late DateTime createdAt;

  @ignore
  String get displayPeriod => periodId;
}
