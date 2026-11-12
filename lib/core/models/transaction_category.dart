import 'package:material_ui/material_ui.dart';

enum TransactionCategoryId {
  foodGroceries,
  transport,
  housing,
  utilities,
  education,
  health,
  business,
  entertainment,
  clothing,
  savings,
  debtRepayment,
  chama,
  charity,
  familySupport,
  airtime,
  payroll,
  income,
  businessIncome,
  uncategorized,
}

class TransactionCategory {
  final TransactionCategoryId id;
  final String name;
  final String swahiliName;
  final String emoji;
  final Color color;
  final bool isIncome;

  const TransactionCategory({
    required this.id,
    required this.name,
    required this.swahiliName,
    required this.emoji,
    required this.color,
    this.isIncome = false,
  });

  String get displayName => name;

  static const List<TransactionCategory> all = [
    TransactionCategory(
      id: TransactionCategoryId.foodGroceries,
      name: 'Food & Groceries',
      swahiliName: 'Chakula',
      emoji: '🛒',
      color: Color(0xFF4CAF50),
    ),
    TransactionCategory(
      id: TransactionCategoryId.transport,
      name: 'Transport',
      swahiliName: 'Usafiri',
      emoji: '🚌',
      color: Color(0xFF2196F3),
    ),
    TransactionCategory(
      id: TransactionCategoryId.housing,
      name: 'Housing & Rent',
      swahiliName: 'Nyumba',
      emoji: '🏠',
      color: Color(0xFF9C27B0),
    ),
    TransactionCategory(
      id: TransactionCategoryId.utilities,
      name: 'Utilities',
      swahiliName: 'Huduma',
      emoji: '💡',
      color: Color(0xFFFF9800),
    ),
    TransactionCategory(
      id: TransactionCategoryId.education,
      name: 'Education',
      swahiliName: 'Elimu',
      emoji: '📚',
      color: Color(0xFF00BCD4),
    ),
    TransactionCategory(
      id: TransactionCategoryId.health,
      name: 'Health & NHIF',
      swahiliName: 'Afya',
      emoji: '🏥',
      color: Color(0xFFF44336),
    ),
    TransactionCategory(
      id: TransactionCategoryId.business,
      name: 'Business Expenses',
      swahiliName: 'Biashara',
      emoji: '💼',
      color: Color(0xFF607D8B),
    ),
    TransactionCategory(
      id: TransactionCategoryId.entertainment,
      name: 'Entertainment',
      swahiliName: 'Burudani',
      emoji: '🎉',
      color: Color(0xFFE91E63),
    ),
    TransactionCategory(
      id: TransactionCategoryId.clothing,
      name: 'Clothing & Shopping',
      swahiliName: 'Mavazi',
      emoji: '👕',
      color: Color(0xFF795548),
    ),
    TransactionCategory(
      id: TransactionCategoryId.savings,
      name: 'Savings',
      swahiliName: 'Akiba',
      emoji: '🏦',
      color: Color(0xFF009688),
    ),
    TransactionCategory(
      id: TransactionCategoryId.debtRepayment,
      name: 'Debt & Fuliza',
      swahiliName: 'Deni',
      emoji: '💳',
      color: Color(0xFFFF5722),
    ),
    TransactionCategory(
      id: TransactionCategoryId.chama,
      name: 'Chama',
      swahiliName: 'Chama',
      emoji: '🤝',
      color: Color(0xFF3F51B5),
    ),
    TransactionCategory(
      id: TransactionCategoryId.charity,
      name: 'Charity & Harambee',
      swahiliName: 'Hisani',
      emoji: '❤️',
      color: Color(0xFFE91E63),
    ),
    TransactionCategory(
      id: TransactionCategoryId.familySupport,
      name: 'Family Support',
      swahiliName: 'Familia',
      emoji: '👨‍👩‍👧',
      color: Color(0xFF8BC34A),
    ),
    TransactionCategory(
      id: TransactionCategoryId.airtime,
      name: 'Airtime & Data',
      swahiliName: 'Airtime',
      emoji: '📱',
      color: Color(0xFF00BCD4),
    ),
    TransactionCategory(
      id: TransactionCategoryId.payroll,
      name: 'Payroll (Salaries Out)',
      swahiliName: 'Mishahara',
      emoji: '💰',
      color: Color(0xFF607D8B),
    ),
    TransactionCategory(
      id: TransactionCategoryId.income,
      name: 'Income',
      swahiliName: 'Mapato',
      emoji: '📈',
      color: Color(0xFF4CAF50),
      isIncome: true,
    ),
    TransactionCategory(
      id: TransactionCategoryId.businessIncome,
      name: 'Business Income',
      swahiliName: 'Mapato ya Biashara',
      emoji: '🏪',
      color: Color(0xFF8BC34A),
      isIncome: true,
    ),
    TransactionCategory(
      id: TransactionCategoryId.uncategorized,
      name: 'Uncategorized',
      swahiliName: 'Bila Kundi',
      emoji: '❓',
      color: Color(0xFF9E9E9E),
    ),
  ];

  static TransactionCategory fromId(TransactionCategoryId id) =>
      all.firstWhere((c) => c.id == id);

  static TransactionCategory get uncategorizedCategory =>
      fromId(TransactionCategoryId.uncategorized);

  static List<TransactionCategory> get expenseCategories =>
      all.where((c) => !c.isIncome && c.id != TransactionCategoryId.uncategorized).toList();

  static List<TransactionCategory> get incomeCategories =>
      all.where((c) => c.isIncome).toList();
}
