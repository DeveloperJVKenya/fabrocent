import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/transaction.dart';
import '../models/transaction_category.dart';
import '../constants/paybill_directory.dart';
import '../services/app_logger.dart';
import 'transaction_type.dart';

/// Core SMS parser engine.
/// Parses M-Pesa confirmation SMS messages into structured Transaction objects.
/// Only processes messages from sender "M-PESA".
class SmsParser {
  SmsParser._();

  static const String mpesaSender = 'M-PESA';

  // Amount pattern: Ksh1,234.56 or Ksh1234 or Ksh-500.00
  static final _amountRe = RegExp(r'Ksh-?([\d,]+\.?\d*)');

  // Transaction ID: starts with letter(s) then alphanumeric, 8-12 chars
  static final _txnIdRe = RegExp(r'^([A-Z0-9]{8,12})\s');

  // Date pattern: 4/11/26 or 04/11/2026
  static final _dateRe = RegExp(r'(\d{1,2}/\d{1,2}/\d{2,4})');

  // Time pattern: 2:30 PM or 14:30
  static final _timeRe = RegExp(r'(\d{1,2}:\d{2}\s?(?:AM|PM)?)', caseSensitive: false);

  static bool isMpesaSms(String sender) =>
      sender.trim().toUpperCase() == 'M-PESA';

  /// Parse a raw M-Pesa SMS body into a Transaction.
  /// Returns null if the message cannot be parsed or is not a transaction.
  static Transaction? parse(String body, String userId) {
    if (body.isEmpty) return null;

    final trimmed = body.trim();

    try {
      // Route to the appropriate parser based on message shape
      if (_containsAny(trimmed, ['sent to', 'Confirmed. Ksh']) &&
          trimmed.contains('sent to') &&
          !trimmed.contains('Pochi la Biashara')) {
        return _parseSendMoney(trimmed, userId);
      }
      if (trimmed.contains('You have received') &&
          trimmed.contains('from') &&
          !trimmed.contains('Pochi la Biashara')) {
        return _parseReceiveMoney(trimmed, userId);
      }
      if (trimmed.contains('paid to') && trimmed.contains('Account Number')) {
        return _parsePaybill(trimmed, userId);
      }
      if (trimmed.contains('paid to') && !trimmed.contains('Account Number')) {
        return _parseBuyGoods(trimmed, userId);
      }
      if (trimmed.contains('withdrawn from')) {
        return _parseWithdraw(trimmed, userId);
      }
      if (trimmed.contains('deposited to your M-PESA')) {
        return _parseDeposit(trimmed, userId);
      }
      if (trimmed.contains('airtime purchased')) {
        return _parseAirtime(trimmed, userId);
      }
      if (trimmed.contains('Pochi la Biashara') && trimmed.contains('received')) {
        return _parsePochiReceive(trimmed, userId);
      }
      if (trimmed.contains('Pochi la Biashara') && trimmed.contains('sent from')) {
        return _parsePochiSend(trimmed, userId);
      }
      if (trimmed.contains('Fuliza M-PESA') && trimmed.contains('used Fuliza')) {
        return _parseFulizaUsed(trimmed, userId);
      }
      if (trimmed.contains('Fuliza M-PESA') && trimmed.contains('repayment')) {
        return _parseFulizaRepayment(trimmed, userId);
      }
      if (trimmed.contains('M-Shwari') && trimmed.contains('transferred to')) {
        return _parseMshwariDeposit(trimmed, userId);
      }
      if (trimmed.contains('M-Shwari') && trimmed.contains('transferred from')) {
        return _parseMshwariWithdraw(trimmed, userId);
      }
      if (trimmed.contains('KCB M-PESA')) {
        return _parseKcbMpesa(trimmed, userId);
      }
      if (trimmed.startsWith(_reversalPrefix(trimmed))) {
        return _parseReversal(trimmed, userId);
      }
      if (trimmed.contains('Lipa Mdogo Mdogo')) {
        return _parseLipaMdogoMdogo(trimmed, userId);
      }
      // Business income: Till received
      if (trimmed.contains('received') && trimmed.contains('for account') &&
          !trimmed.contains('You have received')) {
        return _parseTillReceive(trimmed, userId);
      }

      return _parseUnknown(trimmed, userId);
    } catch (_) {
      return _parseUnknown(trimmed, userId);
    }
  }

  // ─── Individual parsers ───────────────────────────────────────────────────

  static Transaction _parseSendMoney(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.sendMoney, false);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);
    txn.fee = _extractFee(body);

    // "sent to NAME PHONE on"
    final sentToMatch = RegExp(r'sent to (.+?) (0\d{9}|Not provided) on').firstMatch(body);
    if (sentToMatch != null) {
      txn.counterpartyName = _cleanName(sentToMatch.group(1));
      final phone = sentToMatch.group(2)!;
      txn.counterpartyPhoneHashed = _hashPhone(phone);
      txn.counterpartyPhoneLastFour = _lastFour(phone);
    }

    txn.categoryId = TransactionCategoryId.uncategorized;
    return txn;
  }

  static Transaction _parseReceiveMoney(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.receiveMoney, true);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);

    // "received Ksh... from NAME PHONE"
    final fromMatch = RegExp(r'received Ksh[\d,.]+ from (.+?) (0\d{9}|Not provided)').firstMatch(body);
    if (fromMatch != null) {
      txn.counterpartyName = _cleanName(fromMatch.group(1));
      final phone = fromMatch.group(2)!;
      txn.counterpartyPhoneHashed = _hashPhone(phone);
      txn.counterpartyPhoneLastFour = _lastFour(phone);
    }

    // Check if this looks like a salary (large org name, no phone match)
    if (fromMatch == null) {
      final orgMatch = RegExp(r'received Ksh[\d,.]+ from (.+?)\.').firstMatch(body);
      if (orgMatch != null) {
        txn.counterpartyName = _cleanName(orgMatch.group(1));
        txn.type = TransactionType.salary;
      }
    }

    txn.categoryId = txn.type == TransactionType.salary
        ? TransactionCategoryId.income
        : TransactionCategoryId.uncategorized;
    txn.isCategoryConfirmed = txn.type == TransactionType.salary;
    return txn;
  }

  static Transaction _parsePaybill(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.paybill, false);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);
    txn.fee = _extractFee(body);

    // "paid to BUSINESS_NAME PAYBILL_NO Account Number ACCT"
    final match = RegExp(
      r'paid to (.+?) (\d{4,8}) Account Number (\S+)',
    ).firstMatch(body);
    if (match != null) {
      txn.merchantName = _cleanName(match.group(1));
      txn.paybillNumber = match.group(2);
      txn.accountNumber = match.group(3);
    }

    // Auto-suggest category from known paybill directory
    if (txn.paybillNumber != null) {
      final suggestedCategory = PaybillDirectory.getSuggestedCategory(txn.paybillNumber!);
      if (suggestedCategory != null) {
        txn.categoryId = suggestedCategory;
        txn.isCategoryAutoSuggested = true;
        // Override merchant name if we know it
        txn.merchantName = PaybillDirectory.getBusinessName(txn.paybillNumber!) ?? txn.merchantName;
      } else {
        txn.categoryId = TransactionCategoryId.uncategorized;
      }
    } else {
      txn.categoryId = TransactionCategoryId.uncategorized;
    }

    return txn;
  }

  static Transaction _parseBuyGoods(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.buyGoods, false);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);
    txn.fee = _extractFee(body);

    // "paid to MERCHANT_NAME TILL_NO on"
    final match = RegExp(r'paid to (.+?) (\d{4,8}) on').firstMatch(body);
    if (match != null) {
      txn.merchantName = _cleanName(match.group(1));
      txn.tillNumber = match.group(2);
    }

    // Auto-suggest from till directory
    if (txn.tillNumber != null) {
      final entry = TillDirectory.lookup(txn.tillNumber!);
      if (entry != null) {
        txn.categoryId = entry.categoryId;
        txn.isCategoryAutoSuggested = true;
        txn.merchantName = entry.name;
      } else {
        txn.categoryId = TransactionCategoryId.uncategorized;
      }
    } else {
      txn.categoryId = TransactionCategoryId.uncategorized;
    }

    return txn;
  }

  static Transaction _parseWithdraw(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.withdraw, false);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);
    txn.fee = _extractFee(body);

    // "withdrawn from AGENT_NAME AGENT_NO on"
    final match = RegExp(r'withdrawn from (.+?) (0\d{9}) on').firstMatch(body);
    if (match != null) {
      txn.counterpartyName = _cleanName(match.group(1));
      final phone = match.group(2)!;
      txn.counterpartyPhoneHashed = _hashPhone(phone);
      txn.counterpartyPhoneLastFour = _lastFour(phone);
    }

    txn.categoryId = TransactionCategoryId.uncategorized;
    return txn;
  }

  static Transaction _parseDeposit(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.deposit, true);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);

    final match = RegExp(r'by (.+?)\s*New M-PESA').firstMatch(body);
    if (match != null) txn.counterpartyName = _cleanName(match.group(1));

    txn.categoryId = TransactionCategoryId.uncategorized;
    return txn;
  }

  static Transaction _parseAirtime(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.airtime, false);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);

    final match = RegExp(r'purchased for (\d{10,12})').firstMatch(body);
    if (match != null) {
      final phone = match.group(1)!;
      txn.counterpartyPhoneHashed = _hashPhone(phone);
      txn.counterpartyPhoneLastFour = _lastFour(phone);
    }

    txn.categoryId = TransactionCategoryId.airtime;
    txn.isCategoryAutoSuggested = true;
    return txn;
  }

  static Transaction _parsePochiReceive(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.pochiReceive, true);
    txn.isPochi = true;
    txn.amount = _extractFirstAmount(body) ?? 0;
    // Pochi balance is separately stated
    final pochiBalMatch = RegExp(r'Pochi la Biashara balance is Ksh([\d,]+\.?\d*)').firstMatch(body);
    if (pochiBalMatch != null) {
      txn.balanceAfter = _parseAmount(pochiBalMatch.group(1)!);
    }

    final fromMatch = RegExp(r'received Ksh[\d,.]+ from (.+?) (0\d{9}) to your Pochi').firstMatch(body);
    if (fromMatch != null) {
      txn.counterpartyName = _cleanName(fromMatch.group(1));
      final phone = fromMatch.group(2)!;
      txn.counterpartyPhoneHashed = _hashPhone(phone);
      txn.counterpartyPhoneLastFour = _lastFour(phone);
    }

    txn.categoryId = TransactionCategoryId.businessIncome;
    txn.isCategoryAutoSuggested = true;
    return txn;
  }

  static Transaction _parsePochiSend(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.pochiSend, false);
    txn.isPochi = true;
    txn.amount = _extractFirstAmount(body) ?? 0;

    final toMatch = RegExp(r'sent from your Pochi la Biashara to (.+?) (0\d{9})').firstMatch(body);
    if (toMatch != null) {
      txn.counterpartyName = _cleanName(toMatch.group(1));
      final phone = toMatch.group(2)!;
      txn.counterpartyPhoneHashed = _hashPhone(phone);
      txn.counterpartyPhoneLastFour = _lastFour(phone);
    }

    txn.categoryId = TransactionCategoryId.uncategorized;
    return txn;
  }

  static Transaction _parseFulizaUsed(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.fulizaUsed, false);

    final match = RegExp(r'used Fuliza M-PESA Ksh([\d,]+\.?\d*)').firstMatch(body);
    txn.amount = match != null ? _parseAmount(match.group(1)!) : 0;

    txn.categoryId = TransactionCategoryId.debtRepayment;
    txn.isCategoryAutoSuggested = true;
    return txn;
  }

  static Transaction _parseFulizaRepayment(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.fulizaRepayment, false);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);
    txn.categoryId = TransactionCategoryId.debtRepayment;
    txn.isCategoryAutoSuggested = true;
    return txn;
  }

  static Transaction _parseMshwariDeposit(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.mshwariDeposit, false);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);
    txn.categoryId = TransactionCategoryId.savings;
    txn.isCategoryAutoSuggested = true;
    return txn;
  }

  static Transaction _parseMshwariWithdraw(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.mshwariWithdraw, true);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);
    txn.categoryId = TransactionCategoryId.savings;
    txn.isCategoryAutoSuggested = true;
    return txn;
  }

  static Transaction _parseKcbMpesa(String body, String userId) {
    final isCredit = body.contains('transferred from KCB');
    final txn = _baseTransaction(body, userId, TransactionType.kcbMpesa, isCredit);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);
    txn.categoryId = TransactionCategoryId.savings;
    txn.isCategoryAutoSuggested = true;
    return txn;
  }

  static Transaction _parseReversal(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.reversal, true);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);
    txn.categoryId = TransactionCategoryId.uncategorized;
    return txn;
  }

  static Transaction _parseLipaMdogoMdogo(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.lipaMdogoMdogo, false);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);
    txn.categoryId = TransactionCategoryId.debtRepayment;
    txn.isCategoryAutoSuggested = true;
    return txn;
  }

  static Transaction _parseTillReceive(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.tillReceive, true);
    txn.amount = _extractFirstAmount(body) ?? 0;

    // "Ksh500.00 received from CUSTOMER for account BUSINESS at TILL 123456"
    final match = RegExp(r'received from (.+?) for account (.+?) at').firstMatch(body);
    if (match != null) {
      txn.counterpartyName = _cleanName(match.group(1));
      txn.accountNumber = match.group(2)?.trim();
    }

    final tillMatch = RegExp(r'at (\d{4,8})').firstMatch(body);
    if (tillMatch != null) txn.tillNumber = tillMatch.group(1);

    txn.categoryId = TransactionCategoryId.businessIncome;
    txn.isCategoryAutoSuggested = true;
    return txn;
  }

  static Transaction _parseUnknown(String body, String userId) {
    final txn = _baseTransaction(body, userId, TransactionType.unknown, false);
    txn.amount = _extractFirstAmount(body) ?? 0;
    txn.balanceAfter = _extractBalanceAfter(body);
    txn.categoryId = TransactionCategoryId.uncategorized;
    return txn;
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  static Transaction _baseTransaction(
    String body,
    String userId,
    TransactionType type,
    bool isCredit,
  ) {
    final txn = Transaction()
      ..rawSmsBody = body
      ..type = type
      ..isCredit = isCredit
      ..isPochi = false
      ..isCategoryConfirmed = false
      ..isCategoryAutoSuggested = false
      ..userId = userId
      ..categoryId = TransactionCategoryId.uncategorized
      ..syncedAt = DateTime.now()
      ..needsSync = true;

    // Extract transaction ID
    final txnIdMatch = _txnIdRe.firstMatch(body);
    txn.txnId = txnIdMatch?.group(1) ?? _generateFallbackId(body);

    // Extract datetime
    txn.dateTime = _extractDateTime(body);

    return txn;
  }

  static double? _extractFirstAmount(String body) {
    final match = _amountRe.firstMatch(body);
    return match != null ? _parseAmount(match.group(1)!) : null;
  }

  static double? _extractBalanceAfter(String body) {
    // Look for "New M-PESA balance is KshXXX" or "New Pochi la Biashara balance is KshXXX"
    final match = RegExp(r'balance is Ksh([\d,]+\.?\d*)').firstMatch(body);
    return match != null ? _parseAmount(match.group(1)!) : null;
  }

  static double? _extractFee(String body) {
    // "Transaction cost, KshXX.XX"
    final match = RegExp(r'Transaction cost,\s*Ksh([\d,]+\.?\d*)').firstMatch(body);
    if (match == null) return null;
    final fee = _parseAmount(match.group(1)!);
    return fee > 0 ? fee : null;
  }

  static double _parseAmount(String raw) {
    return double.tryParse(raw.replaceAll(',', '')) ?? 0;
  }

  static DateTime _extractDateTime(String body) {
    try {
      final dateMatch = _dateRe.firstMatch(body);
      final timeMatch = _timeRe.firstMatch(body);

      if (dateMatch == null) return DateTime.now();

      final dateParts = dateMatch.group(1)!.split('/');
      if (dateParts.length < 3) return DateTime.now();

      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      var year = int.parse(dateParts[2]);
      if (year < 100) year += 2000; // "26" → 2026

      int hour = 0, minute = 0;
      if (timeMatch != null) {
        final timeStr = timeMatch.group(1)!.trim();
        final isPm = timeStr.toUpperCase().contains('PM');
        final isAm = timeStr.toUpperCase().contains('AM');
        final cleaned = timeStr.replaceAll(RegExp(r'[APM\s]', caseSensitive: false), '');
        final timeParts = cleaned.split(':');
        if (timeParts.length >= 2) {
          hour = int.parse(timeParts[0]);
          minute = int.parse(timeParts[1]);
          if (isPm && hour != 12) hour += 12;
          if (isAm && hour == 12) hour = 0;
        }
      }

      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return DateTime.now();
    }
  }

  static String _hashPhone(String phone) {
    final normalized = phone.replaceAll(RegExp(r'[^\d]'), '');
    final bytes = utf8.encode(normalized);
    return sha256.convert(bytes).toString();
  }

  static String _lastFour(String phone) {
    final normalized = phone.replaceAll(RegExp(r'[^\d]'), '');
    return normalized.length >= 4 ? normalized.substring(normalized.length - 4) : normalized;
  }

  static String _cleanName(String? raw) {
    if (raw == null) return '';
    return raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool _containsAny(String text, List<String> patterns) =>
      patterns.any((p) => text.contains(p));

  static String _reversalPrefix(String body) {
    final match = RegExp(r'^[A-Z0-9]+\s+Reversed').firstMatch(body);
    return match?.group(0) ?? '___NO_MATCH___';
  }

  static String _generateFallbackId(String body) {
    final bytes = utf8.encode(body.substring(0, body.length.clamp(0, 100)));
    return 'FB${sha256.convert(bytes).toString().substring(0, 10).toUpperCase()}';
  }

  /// Parse all M-Pesa SMS from the inbox, skipping non-M-Pesa messages.
  static List<Transaction> parseAll(List<Map<String, dynamic>> smsList, String userId) {
    AppLogger.sms('parseAll: processing ${smsList.length} raw SMS messages');
    final results = <Transaction>[];
    int skipped = 0;
    for (final sms in smsList) {
      final sender = (sms['address'] as String? ?? '').trim().toUpperCase();
      if (sender != 'M-PESA') { skipped++; continue; }

      final body = sms['body'] as String? ?? '';
      if (!body.contains('Confirmed') && !body.contains('Reversed')) { skipped++; continue; }

      final txn = parse(body, userId);
      if (txn != null) results.add(txn);
    }
    AppLogger.sms(
      'parseAll: ✅ ${results.length} transactions parsed, '
      '$skipped skipped (non-M-PESA or unrecognized)',
    );
    return results;
  }
}
