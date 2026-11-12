import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/isar_service.dart';
import '../models/transaction.dart';
import '../providers/firebase_providers.dart';
import 'app_logger.dart';

class FirestoreSyncService {
  final FirebaseFirestore _firestore;

  FirestoreSyncService(this._firestore);

  Future<int> syncPendingTransactions(String userId) async {
    AppLogger.sync('Checking for unsynced transactions — userId=$userId');
    final pending = await IsarService.getUnsyncedTransactions(userId);
    if (pending.isEmpty) {
      AppLogger.sync('Nothing to sync — all transactions up to date');
      return 0;
    }

    AppLogger.sync('Syncing ${pending.length} pending transaction(s) to Firestore');
    final col = _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions');

    // Firestore batch max is 500 — chunk if necessary
    const chunkSize = 400;
    int batchNum = 0;
    for (var i = 0; i < pending.length; i += chunkSize) {
      batchNum++;
      final chunk = pending.sublist(
          i, i + chunkSize > pending.length ? pending.length : i + chunkSize);
      AppLogger.sync('Committing batch $batchNum (${chunk.length} items)');
      final batch = _firestore.batch();
      for (final txn in chunk) {
        batch.set(col.doc(txn.txnId), _txnToMap(txn), SetOptions(merge: true));
      }
      await batch.commit();
      AppLogger.sync('Batch $batchNum committed');
    }

    await IsarService.markTransactionsSynced(pending.map((t) => t.id).toList());
    AppLogger.sync('✅ Sync complete — ${pending.length} transaction(s) uploaded');
    return pending.length;
  }

  Map<String, dynamic> _txnToMap(Transaction txn) => {
        'txnId': txn.txnId,
        'type': txn.type.name,
        'amount': txn.amount,
        'balanceAfter': txn.balanceAfter,
        'fee': txn.fee,
        'dateTime': txn.dateTime.toIso8601String(),
        'isCredit': txn.isCredit,
        'isPochi': txn.isPochi,
        'counterpartyName': txn.counterpartyName,
        'counterpartyPhoneHashed': txn.counterpartyPhoneHashed,
        'merchantName': txn.merchantName,
        'paybillNumber': txn.paybillNumber,
        'accountNumber': txn.accountNumber,
        'tillNumber': txn.tillNumber,
        'categoryId': txn.categoryId.name,
        'isCategoryConfirmed': txn.isCategoryConfirmed,
        'periodId': txn.periodId,
        'userId': txn.userId,
        'syncedAt': FieldValue.serverTimestamp(),
      };
}

final firestoreSyncServiceProvider = Provider<FirestoreSyncService>((ref) {
  return FirestoreSyncService(ref.watch(firestoreProvider));
});
