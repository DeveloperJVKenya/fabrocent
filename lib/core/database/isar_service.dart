import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/transaction.dart';
import '../models/transaction_category.dart';
import '../models/financial_period.dart';
import '../models/budget.dart';
import '../services/app_logger.dart';

class IsarService {
  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null) {
      AppLogger.db('♻️ IsarService: Reusing existing Isar instance');
    }
    _isar ??= await _open();
    return _isar!;
  }

  static Future<Isar> _open() async {
    AppLogger.db('🏗️ IsarService: Opening local database');
    try {
      final dir = await getApplicationDocumentsDirectory();
      AppLogger.db('🏗️ IsarService: Database directory — ${dir.path}');
      final db = await Isar.open(
        [
          TransactionSchema,
          FinancialPeriodSchema,
          BudgetAllocationSchema,
          BudgetPlanSchema,
        ],
        directory: dir.path,
        name: 'fabrocent',
      );
      AppLogger.db('✅ IsarService: Database opened successfully');
      return db;
    } catch (e, st) {
      AppLogger.error('💾 DB', 'IsarService: Failed to open database', e, st);
      rethrow;
    }
  }

  // ─── Transactions ────────────────────────────────────────────────────────

  static Future<void> saveTransaction(Transaction txn) async {
    AppLogger.db('Saving transaction ${txn.txnId}');
    final db = await instance;
    await db.writeTxn(() => db.transactions.put(txn));
    AppLogger.db('✅ Transaction saved ${txn.txnId}');
  }

  static Future<void> saveTransactions(List<Transaction> txns) async {
    AppLogger.db('Saving ${txns.length} transactions');
    final db = await instance;
    await db.writeTxn(() => db.transactions.putAll(txns));
    AppLogger.db('✅ ${txns.length} transactions saved');
  }

  static Future<Transaction?> getTransaction(String txnId) async {
    final db = await instance;
    return db.transactions.where().txnIdEqualTo(txnId).findFirst();
  }

  static Future<List<Transaction>> getTransactionsForPeriod({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) async {
    final db = await instance;
    return db.transactions
        .where()
        .userIdEqualTo(userId)
        .filter()
        .dateTimeBetween(start, end)
        .sortByDateTimeDesc()
        .findAll();
  }

  static Future<List<Transaction>> getUntaggedTransactions(String userId) async {
    final db = await instance;
    return db.transactions
        .where()
        .userIdEqualTo(userId)
        .filter()
        .categoryIdEqualTo(TransactionCategoryId.uncategorized)
        .sortByDateTimeDesc()
        .findAll();
  }

  static Future<List<Transaction>> getUnsyncedTransactions(String userId) async {
    final db = await instance;
    return db.transactions
        .where()
        .userIdEqualTo(userId)
        .filter()
        .needsSyncEqualTo(true)
        .findAll();
  }

  static Future<void> updateTransactionCategory({
    required int id,
    required TransactionCategoryId categoryId,
    required bool confirmed,
  }) async {
    final db = await instance;
    await db.writeTxn(() async {
      final txn = await db.transactions.get(id);
      if (txn != null) {
        txn.categoryId = categoryId;
        txn.isCategoryConfirmed = confirmed;
        txn.categorizedAt = DateTime.now();
        txn.needsSync = true;
        await db.transactions.put(txn);
      }
    });
  }

  static Stream<List<Transaction>> watchTransactions({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) {
    return Isar.getInstance('fabrocent')!
        .transactions
        .where()
        .userIdEqualTo(userId)
        .filter()
        .dateTimeBetween(start, end)
        .sortByDateTimeDesc()
        .watch(fireImmediately: true);
  }

  static Future<Transaction?> getTransactionById(int id) async {
    final db = await instance;
    return db.transactions.get(id);
  }

  static Future<Map<TransactionCategoryId, double>> getCategoryTotals({
    required String userId,
    required DateTime start,
    required DateTime end,
    required bool creditOnly,
  }) async {
    final txns = await getTransactionsForPeriod(
      userId: userId,
      start: start,
      end: end,
    );

    final totals = <TransactionCategoryId, double>{};
    for (final txn in txns) {
      if (txn.isCredit != creditOnly) continue;
      totals[txn.categoryId] = (totals[txn.categoryId] ?? 0) + txn.amount;
    }
    return totals;
  }

  static Future<double> getCategoryTotal({
    required String userId,
    required DateTime start,
    required DateTime end,
    required TransactionCategoryId categoryId,
  }) async {
    final txns = await getTransactionsForPeriod(
      userId: userId,
      start: start,
      end: end,
    );
    return txns
        .where((t) => !t.isCredit && t.categoryId == categoryId)
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  // ─── Financial Periods ───────────────────────────────────────────────────

  static Future<FinancialPeriod?> getActivePeriod(String userId) async {
    final db = await instance;
    return db.financialPeriods
        .where()
        .userIdEqualTo(userId)
        .filter()
        .isActiveEqualTo(true)
        .findFirst();
  }

  static Future<List<FinancialPeriod>> getAllPeriods(String userId) async {
    final db = await instance;
    return db.financialPeriods
        .where()
        .userIdEqualTo(userId)
        .sortByStartDateDesc()
        .findAll();
  }

  static Future<void> savePeriod(FinancialPeriod period) async {
    final db = await instance;
    await db.writeTxn(() => db.financialPeriods.put(period));
  }

  // ─── Budget ──────────────────────────────────────────────────────────────

  static Future<List<BudgetAllocation>> getBudgetAllocations({
    required String userId,
    required String periodId,
  }) async {
    final db = await instance;
    return db.budgetAllocations
        .where()
        .userIdEqualTo(userId)
        .filter()
        .periodIdEqualTo(periodId)
        .findAll();
  }

  static Future<void> saveBudgetAllocation(BudgetAllocation allocation) async {
    final db = await instance;
    await db.writeTxn(() => db.budgetAllocations.put(allocation));
  }

  static Future<void> saveBudgetAllocations(List<BudgetAllocation> allocations) async {
    final db = await instance;
    await db.writeTxn(() => db.budgetAllocations.putAll(allocations));
  }

  static Future<void> updateBudgetSpent({
    required String userId,
    required String periodId,
    required TransactionCategoryId categoryId,
    required double amount,
  }) async {
    final db = await instance;
    await db.writeTxn(() async {
      final alloc = await db.budgetAllocations
          .where()
          .userIdEqualTo(userId)
          .filter()
          .periodIdEqualTo(periodId)
          .and()
          .categoryIdEqualTo(categoryId)
          .findFirst();
      if (alloc != null) {
        alloc.spentAmount += amount;
        await db.budgetAllocations.put(alloc);
      }
    });
  }

  static Future<BudgetPlan?> getBudgetPlan({
    required String userId,
    required String periodId,
  }) async {
    final db = await instance;
    final planId = '${userId}_$periodId';
    return db.budgetPlans.where().planIdEqualTo(planId).findFirst();
  }

  static Future<void> saveBudgetPlan(BudgetPlan plan) async {
    final db = await instance;
    await db.writeTxn(() => db.budgetPlans.put(plan));
  }

  // ─── Clear all local data for a user ────────────────────────────────────

  static Future<void> clearUserData(String userId) async {
    AppLogger.warn('💾 DB', 'Clearing ALL local data for user $userId');
    final db = await instance;
    await db.writeTxn(() async {
      await db.transactions.where().userIdEqualTo(userId).deleteAll();
      await db.financialPeriods.where().userIdEqualTo(userId).deleteAll();
      await db.budgetAllocations.where().userIdEqualTo(userId).deleteAll();
      await db.budgetPlans.where().userIdEqualTo(userId).deleteAll();
    });
    AppLogger.db('✅ All local data cleared for user $userId');
  }

  static Future<void> markTransactionsSynced(List<int> ids) async {
    final db = await instance;
    final now = DateTime.now();
    await db.writeTxn(() async {
      final txns = await db.transactions.getAll(ids);
      for (final txn in txns) {
        if (txn != null) {
          txn.needsSync = false;
          txn.syncedAt = now;
        }
      }
      await db.transactions.putAll(txns.whereType<Transaction>().toList());
    });
  }
}
