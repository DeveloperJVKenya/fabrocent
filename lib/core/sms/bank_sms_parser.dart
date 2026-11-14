import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/transaction.dart';
import '../models/transaction_category.dart';
import '../services/app_logger.dart';
import 'known_banks.dart';
import 'transaction_type.dart';

/// Parses bank confirmation SMS messages into Transaction objects.
/// Handles the generic debit/credit format used by most Kenyan banks.
class BankSmsParser {
  BankSmsParser._();

  // Matches KES or Ksh amounts: "KES 5,000.00" / "KES5000" / "Ksh 1,234.56"
  static final _amountRe = RegExp(r'(?:KES|Ksh)\s*([\d,]+\.?\d*)', caseSensitive: false);

  // Balance after: "Available balance: KES X" / "Avail bal KES X" / "Bal: KES X"
  static final _balanceRe = RegExp(
    r'(?:available\s+balance|avail(?:able)?\s+bal(?:ance)?|balance|bal)[^:KES\d]*(?:KES|Ksh)\s*([\d,]+\.?\d*)',
    caseSensitive: false,
  );

  // Last 4 account digits: "acct XXXX" / "account ending XXXX" / "A/C: XXXX"
  static final _accountRe = RegExp(
    r'(?:acct|account|a\/c|acc)(?:\s+ending|\s+no\.?|[:\s]+)[\*X]*(\d{4})',
    caseSensitive: false,
  );

  // Date extraction: "10/11/26" / "10-Nov-2026" / "10 Nov 2026"
  static final _dateRe = RegExp(
    r'(\d{1,2})[\/\-\s](\d{1,2}|[A-Za-z]{3})[\/\-\s](\d{2,4})',
  );

  static bool isBankSms(String sender) => bankForSender(sender) != null;

  /// Returns true if the message body looks like a financial transaction SMS.
  static bool isTransactionSms(String body) {
    final lower = body.toLowerCase();
    final hasFinancialWord = lower.contains('debit') ||
        lower.contains('credit') ||
        lower.contains('debited') ||
        lower.contains('credited') ||
        lower.contains('withdraw') ||
        lower.contains('deposit') ||
        lower.contains('transfer');
    final hasAmount = _amountRe.hasMatch(body);
    return hasFinancialWord && hasAmount;
  }

  /// Parse a bank SMS into a Transaction.  Returns null if unrecognised.
  static Transaction? parse(String body, String sender, String userId) {
    if (!isTransactionSms(body)) return null;

    final bank = bankForSender(sender);
    if (bank == null) {
      AppLogger.sms('BankSmsParser: unrecognised sender "$sender" — skipping');
      return null;
    }

    final lower = body.toLowerCase();
    final isCredit = _detectCredit(lower);

    final txn = Transaction()
      ..rawSmsBody     = body
      ..type           = isCredit ? TransactionType.bankCredit : TransactionType.bankDebit
      ..isCredit       = isCredit
      ..isPochi        = false
      ..isCategoryConfirmed     = false
      ..isCategoryAutoSuggested = false
      ..userId   = userId
      ..syncedAt = DateTime.now()
      ..needsSync = true
      ..counterpartyName = bank.name
      ..merchantName     = null;

    txn.amount       = _extractAmount(body) ?? 0;
    txn.balanceAfter = _extractBalance(body);
    txn.accountNumber = _extractAccount(body);
    txn.dateTime     = _extractDate(body);
    txn.txnId        = _generateId(body, sender);

    // Category: credit → income (unconfirmed), debit → uncategorized
    txn.categoryId = isCredit
        ? TransactionCategoryId.income
        : TransactionCategoryId.uncategorized;
    txn.isCategoryAutoSuggested = isCredit;

    AppLogger.sms(
      'BankSmsParser: parsed ${isCredit ? "credit" : "debit"} '
      'Ksh ${txn.amount.toStringAsFixed(0)} from ${bank.name}',
    );
    return txn;
  }

  static bool _detectCredit(String lower) {
    // Explicit debit keywords take priority
    if (lower.contains('debited') || lower.contains('debit ') || lower.contains('dr ')) {
      return false;
    }
    if (lower.contains('credited') || lower.contains('credit ') || lower.contains('cr ')) {
      return true;
    }
    // Amount before "deposit" or "received" implies credit
    if (lower.contains('deposit') || lower.contains('received')) return true;
    if (lower.contains('withdraw') || lower.contains('payment') || lower.contains('purchase')) return false;
    // Default: debit (conservative)
    return false;
  }

  static double? _extractAmount(String body) {
    // Find the first meaningful KES/Ksh amount (not the balance)
    final matches = _amountRe.allMatches(body).toList();
    if (matches.isEmpty) return null;
    // The first amount is usually the transaction amount
    return _parse(matches.first.group(1)!);
  }

  static double? _extractBalance(String body) {
    final m = _balanceRe.firstMatch(body);
    return m != null ? _parse(m.group(1)!) : null;
  }

  static String? _extractAccount(String body) {
    final m = _accountRe.firstMatch(body);
    return m?.group(1);
  }

  static DateTime _extractDate(String body) {
    try {
      final m = _dateRe.firstMatch(body);
      if (m == null) return DateTime.now();

      final d = int.tryParse(m.group(1)!) ?? 1;
      final monthRaw = m.group(2)!;
      final yearRaw  = m.group(3)!;

      final month = int.tryParse(monthRaw) ?? _monthFromName(monthRaw);
      var year = int.tryParse(yearRaw) ?? DateTime.now().year;
      if (year < 100) year += 2000;

      return DateTime(year, month, d);
    } catch (_) {
      return DateTime.now();
    }
  }

  static int _monthFromName(String s) {
    const names = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'];
    final idx = names.indexWhere((n) => s.toLowerCase().startsWith(n));
    return idx >= 0 ? idx + 1 : DateTime.now().month;
  }

  static double _parse(String raw) =>
      double.tryParse(raw.replaceAll(',', '')) ?? 0;

  static String _generateId(String body, String sender) {
    final bytes = utf8.encode('$sender:${body.substring(0, body.length.clamp(0, 120))}');
    return 'BK${sha256.convert(bytes).toString().substring(0, 10).toUpperCase()}';
  }

  /// Parse a list of raw SMS maps for bank messages (from multiple senders).
  static List<Transaction> parseAll(
    List<Map<String, dynamic>> smsList,
    String userId,
    Set<String> enabledSenders,
  ) {
    final results = <Transaction>[];
    int skipped = 0;

    for (final sms in smsList) {
      final sender = (sms['address'] as String? ?? '').trim();
      final senderUpper = sender.toUpperCase();

      // Only process senders the user has opted into
      if (!enabledSenders.any((s) => s.toUpperCase() == senderUpper)) {
        skipped++;
        continue;
      }

      final body = sms['body'] as String? ?? '';
      final txn = parse(body, sender, userId);
      if (txn != null) results.add(txn);
    }

    AppLogger.sms(
      'BankSmsParser.parseAll: ✅ ${results.length} bank transactions, '
      '$skipped skipped (not opted-in or unrecognised)',
    );
    return results;
  }
}
