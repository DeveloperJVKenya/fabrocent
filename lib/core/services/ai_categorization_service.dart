import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:firebase_ai/firebase_ai.dart';
import '../models/transaction.dart';
import '../models/transaction_category.dart';
import 'ai_error_helper.dart';
import 'app_logger.dart';

class AiCategorizationService {
  AiCategorizationService._();

  static const String _model = 'gemini-2.5-flash';

  /// Non-technical message describing the most recent AI call failure.
  /// Set by every catch block; cleared on a successful call.
  static String? lastErrorMessage;

  // In-memory cache: counterparty|isCredit → suggested category
  static final Map<String, TransactionCategoryId> _cache = {};

  static Future<TransactionCategoryId?> suggestCategory(Transaction txn) async {
    final cacheKey = '${txn.displayCounterparty}|${txn.isCredit}';

    if (_cache.containsKey(cacheKey)) {
      AppLogger.ai('♻️ Cache hit for "${txn.displayCounterparty}" → ${_cache[cacheKey]!.name}');
      return _cache[cacheKey];
    }

    AppLogger.ai('Calling Gemini for "${txn.displayCounterparty}" (${txn.isCredit ? "credit" : "debit"})');
    lastErrorMessage = null;

    try {
      final model =
          FirebaseAI.agentPlatform(location: 'us-central1').generativeModel(
        model: _model,
        generationConfig: GenerationConfig(
          temperature: 0,
          maxOutputTokens: 32,
        ),
      );

      final categories = txn.isCredit
          ? TransactionCategory.incomeCategories
          : TransactionCategory.expenseCategories;
      final catList = categories.map((c) => c.id.name).join(', ');

      final prompt = '''
Classify this M-Pesa transaction into ONE of these categories: $catList

Transaction: ${txn.displayCounterparty}
Amount: ${txn.formattedAmount}
Direction: ${txn.isCredit ? 'received/income' : 'sent/expense'}

Reply with ONLY the category id (lowercase_underscore_name). No punctuation, no explanation.''';

      final response = await model
          .generateContent([Content.text(prompt)]).timeout(const Duration(seconds: 10));

      final raw = _parseCategoryResponse(response.text ?? '');
      AppLogger.ai('📥 Gemini response: "$raw"');

      final match = TransactionCategoryId.values
          .where((id) => id.name == raw)
          .firstOrNull;

      if (match != null) {
        _cache[cacheKey] = match;
        AppLogger.ai('✅ Categorized "${txn.displayCounterparty}" → $raw');
      } else {
        AppLogger.warn('🤖 AI', 'Unknown category id from Gemini: "$raw"');
      }

      return match;
    } on FirebaseException catch (e, st) {
      AppLogger.error('🤖 AI', 'Firebase error ${e.code}', e, st);
      lastErrorMessage = humanizeAiError(e);
      return null;
    } catch (e, st) {
      AppLogger.error('🤖 AI', 'Unexpected error', e, st);
      lastErrorMessage = humanizeAiError(e);
      return null;
    }
  }

  static String _parseCategoryResponse(String rawText) {
    String cleaned = rawText.trim().toLowerCase();

    // Strip markdown code fences
    if (cleaned.contains('```')) {
      cleaned = cleaned.replaceAll(RegExp(r'```(?:\w+)?'), '').trim();
    }

    // Strip outer quotes
    if (cleaned.startsWith('"') && cleaned.endsWith('"') && cleaned.length > 2) {
      cleaned = cleaned.substring(1, cleaned.length - 1).trim();
    }

    // Take the first token only (guard against multi-word responses)
    cleaned = cleaned.split(RegExp(r'[\s\n,.]')).first.trim();
    return cleaned;
  }

  static void clearCache() => _cache.clear();
}
