import '../models/transaction_category.dart';

class PaybillDirectory {
  PaybillDirectory._();

  // Known Kenyan paybill numbers → (business name, suggested category)
  static const Map<String, PaybillEntry> entries = {
    '888880': PaybillEntry('Kenya Power (KPLC)', TransactionCategoryId.utilities),
    '888888': PaybillEntry('Kenya Power (Prepaid)', TransactionCategoryId.utilities),
    '101010': PaybillEntry('Nairobi City Water', TransactionCategoryId.utilities),
    '400222': PaybillEntry('NHIF', TransactionCategoryId.health),
    '601300': PaybillEntry('NSSF', TransactionCategoryId.savings),
    '400200': PaybillEntry('KRA iTax', TransactionCategoryId.utilities),
    '247247': PaybillEntry('Equity Bank', TransactionCategoryId.debtRepayment),
    '522522': PaybillEntry('KCB Bank', TransactionCategoryId.debtRepayment),
    '400400': PaybillEntry('Co-operative Bank', TransactionCategoryId.debtRepayment),
    '542542': PaybillEntry('Standard Chartered', TransactionCategoryId.debtRepayment),
    '329329': PaybillEntry('ABSA Bank', TransactionCategoryId.debtRepayment),
    '200999': PaybillEntry('Zuku Internet & TV', TransactionCategoryId.utilities),
    '290290': PaybillEntry('DStv', TransactionCategoryId.entertainment),
    '802000': PaybillEntry('Safaricom Postpaid', TransactionCategoryId.airtime),
    '100': PaybillEntry('Airtel', TransactionCategoryId.airtime),
    '303030': PaybillEntry('Faiba 4G', TransactionCategoryId.utilities),
    '747747': PaybillEntry('Safaricom Home Fiber', TransactionCategoryId.utilities),
    '345345': PaybillEntry('Liquid Telecom', TransactionCategoryId.utilities),
    '333222': PaybillEntry('NHIF (Voluntary)', TransactionCategoryId.health),
    '900200': PaybillEntry('University of Nairobi', TransactionCategoryId.education),
    '572572': PaybillEntry('Kenyatta University', TransactionCategoryId.education),
    '290000': PaybillEntry('NITA (Technical Training)', TransactionCategoryId.education),
    '8005550': PaybillEntry('Nairobi County', TransactionCategoryId.utilities),
  };

  static PaybillEntry? lookup(String paybillNumber) => entries[paybillNumber];

  static String? getBusinessName(String paybillNumber) => entries[paybillNumber]?.name;

  static TransactionCategoryId? getSuggestedCategory(String paybillNumber) =>
      entries[paybillNumber]?.categoryId;
}

class PaybillEntry {
  final String name;
  final TransactionCategoryId categoryId;
  const PaybillEntry(this.name, this.categoryId);
}

// Known Till numbers for large merchants (expandable via Remote Config)
class TillDirectory {
  TillDirectory._();

  static const Map<String, TillEntry> entries = {
    // Supermarkets - example entries; real ones come from Remote Config
    '8080': TillEntry('Naivas Supermarket', TransactionCategoryId.foodGroceries),
    '7090': TillEntry('Quickmart', TransactionCategoryId.foodGroceries),
    '5050': TillEntry('Carrefour', TransactionCategoryId.foodGroceries),
    // Petrol stations
    '1000': TillEntry('Total Energies', TransactionCategoryId.transport),
    '2000': TillEntry('Rubis', TransactionCategoryId.transport),
  };

  static TillEntry? lookup(String tillNumber) => entries[tillNumber];
}

class TillEntry {
  final String name;
  final TransactionCategoryId categoryId;
  const TillEntry(this.name, this.categoryId);
}
