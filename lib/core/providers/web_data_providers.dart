import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';
import '../models/transaction_category.dart';
import '../services/app_logger.dart';
import '../sms/transaction_type.dart';
import 'firebase_providers.dart';

// Firestore-backed transaction stream for the current calendar month (web only).
final webTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    AppLogger.web('webTransactions: no user — returning empty stream');
    return Stream.value([]);
  }

  final now = DateTime.now();
  final start = DateTime(now.year, now.month, 1).toIso8601String();
  final end = DateTime(now.year, now.month + 1, 1).toIso8601String();

  AppLogger.web('webTransactions: subscribing to Firestore for uid=${user.uid} ($start → $end)');

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('transactions')
      .where('dateTime', isGreaterThanOrEqualTo: start)
      .where('dateTime', isLessThan: end)
      .orderBy('dateTime', descending: true)
      .snapshots()
      .map((snap) {
        final txns = snap.docs
            .map((doc) => _fromFirestore(doc.data(), user.uid))
            .whereType<Transaction>()
            .toList();
        AppLogger.web('webTransactions: received ${snap.docs.length} docs → ${txns.length} parsed');
        return txns;
      });
});

Transaction? _fromFirestore(Map<String, dynamic> d, String userId) {
  try {
    return Transaction()
      ..txnId = (d['txnId'] as String?) ?? ''
      ..rawSmsBody = ''
      ..type = TransactionType.values.firstWhere(
        (t) => t.name == (d['type'] as String? ?? ''),
        orElse: () => TransactionType.unknown,
      )
      ..amount = (d['amount'] as num?)?.toDouble() ?? 0
      ..balanceAfter = (d['balanceAfter'] as num?)?.toDouble()
      ..fee = (d['fee'] as num?)?.toDouble()
      ..dateTime =
          DateTime.tryParse(d['dateTime'] as String? ?? '') ?? DateTime.now()
      ..isCredit = d['isCredit'] as bool? ?? false
      ..isPochi = d['isPochi'] as bool? ?? false
      ..counterpartyName = d['counterpartyName'] as String?
      ..counterpartyPhoneHashed = d['counterpartyPhoneHashed'] as String?
      ..counterpartyPhoneLastFour = null
      ..merchantName = d['merchantName'] as String?
      ..paybillNumber = d['paybillNumber'] as String?
      ..accountNumber = d['accountNumber'] as String?
      ..tillNumber = d['tillNumber'] as String?
      ..categoryId = TransactionCategoryId.values.firstWhere(
        (c) => c.name == (d['categoryId'] as String? ?? ''),
        orElse: () => TransactionCategoryId.uncategorized,
      )
      ..isCategoryConfirmed = d['isCategoryConfirmed'] as bool? ?? false
      ..isCategoryAutoSuggested = false
      ..categorizedAt = null
      ..userId = userId
      ..periodId = d['periodId'] as String?
      ..syncedAt = DateTime.now()
      ..needsSync = false;
  } catch (e) {
    AppLogger.error('🌐 WEB', 'Failed to parse Firestore transaction doc', e);
    return null;
  }
}
