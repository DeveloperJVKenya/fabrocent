import 'package:isar_community/isar.dart';
import '../sms/transaction_type.dart';
import 'transaction_category.dart';

part 'transaction.g.dart';

@Collection()
class Transaction {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String txnId; // M-Pesa transaction code e.g. "QHJ8K3LP1Z"

  late String rawSmsBody; // Store raw SMS for reparse if Safaricom changes format

  @Enumerated(EnumType.ordinal)
  late TransactionType type;

  late double amount;
  late double? balanceAfter;
  late double? fee;

  @Index()
  late DateTime dateTime;

  late bool isCredit; // true = money in (credit), false = money out (debit)
  late bool isPochi;  // transaction belongs to Pochi la Biashara wallet

  late String? counterpartyName;
  late String? counterpartyPhoneHashed; // SHA-256 hash — never store raw number
  late String? counterpartyPhoneLastFour; // last 4 digits for display only

  late String? merchantName;
  late String? paybillNumber;
  late String? accountNumber;
  late String? tillNumber;

  @Enumerated(EnumType.ordinal)
  late TransactionCategoryId categoryId;

  late bool isCategoryConfirmed; // user explicitly confirmed vs auto-suggested
  late bool isCategoryAutoSuggested;
  late DateTime? categorizedAt;

  @Index()
  late String userId; // Firebase UID

  late String? periodId; // which financial period this belongs to

  late DateTime syncedAt; // when last synced to Firestore
  late bool needsSync; // dirty flag for Firestore sync

  @ignore
  TransactionCategory get category => TransactionCategory.fromId(categoryId);

  @ignore
  bool get isUntagged => categoryId == TransactionCategoryId.uncategorized;

  @ignore
  String get formattedAmount {
    final sign = isCredit ? '+' : '-';
    return '$sign Ksh ${_formatAmount(amount)}';
  }

  @ignore
  String get displayCounterparty {
    if (counterpartyName != null && counterpartyName!.isNotEmpty) {
      return counterpartyName!;
    }
    if (counterpartyPhoneLastFour != null) {
      return '••••${counterpartyPhoneLastFour!}';
    }
    if (merchantName != null) return merchantName!;
    return type.displayName;
  }

  static String _formatAmount(double amount) {
    if (amount >= 1000) {
      final parts = amount.toStringAsFixed(2).split('.');
      final intPart = parts[0];
      final buffer = StringBuffer();
      for (var i = 0; i < intPart.length; i++) {
        if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
        buffer.write(intPart[i]);
      }
      return '${buffer.toString()}.${parts[1]}';
    }
    return amount.toStringAsFixed(2);
  }

  Transaction copyWith({
    TransactionCategoryId? categoryId,
    bool? isCategoryConfirmed,
    DateTime? categorizedAt,
    bool? needsSync,
  }) {
    return Transaction()
      ..id = id
      ..txnId = txnId
      ..rawSmsBody = rawSmsBody
      ..type = type
      ..amount = amount
      ..balanceAfter = balanceAfter
      ..fee = fee
      ..dateTime = dateTime
      ..isCredit = isCredit
      ..isPochi = isPochi
      ..counterpartyName = counterpartyName
      ..counterpartyPhoneHashed = counterpartyPhoneHashed
      ..counterpartyPhoneLastFour = counterpartyPhoneLastFour
      ..merchantName = merchantName
      ..paybillNumber = paybillNumber
      ..accountNumber = accountNumber
      ..tillNumber = tillNumber
      ..categoryId = categoryId ?? this.categoryId
      ..isCategoryConfirmed = isCategoryConfirmed ?? this.isCategoryConfirmed
      ..isCategoryAutoSuggested = isCategoryAutoSuggested
      ..categorizedAt = categorizedAt ?? this.categorizedAt
      ..userId = userId
      ..periodId = periodId
      ..syncedAt = syncedAt
      ..needsSync = needsSync ?? this.needsSync;
  }
}
