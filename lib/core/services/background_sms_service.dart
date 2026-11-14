import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../database/isar_service.dart';
import '../models/financial_period.dart';
import '../providers/settings_provider.dart';
import '../sms/bank_sms_parser.dart';
import '../sms/sms_channel.dart';
import '../sms/sms_parser.dart';
import 'app_logger.dart';

const _kSmsCheckTask = 'fabrocent.sms.check';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != _kSmsCheckTask) return true;

    final userId = inputData?['userId'] as String?;
    if (userId == null) {
      AppLogger.sms('Background task: no userId in inputData — skipping');
      return true;
    }

    AppLogger.sms('Background SMS check started for userId=$userId');

    try {
      final messages = await SmsChannel.getInboxSms(address: 'M-PESA');
      AppLogger.sms('Background: read ${messages.length} M-Pesa SMS from inbox');

      final cutoff = DateTime.now().subtract(const Duration(hours: 25));
      final recent = messages.where((m) {
        return DateTime.fromMillisecondsSinceEpoch(m.date).isAfter(cutoff);
      }).toList();

      if (recent.isEmpty) {
        AppLogger.sms('Background: no SMS in the last 25h — nothing to process');
        return true;
      }

      AppLogger.sms('Background: processing ${recent.length} recent SMS');
      final rawList = recent
          .map((m) => {'address': m.address, 'body': m.body, 'date': m.date})
          .toList();

      final transactions = SmsParser.parseAll(rawList, userId);
      for (final txn in transactions) {
        txn.periodId = FinancialPeriod.idForDate(txn.dateTime);
      }
      await IsarService.saveTransactions(transactions);
      AppLogger.sms('Background: saved ${transactions.length} new transaction(s) to Isar');

      // Bank SMS (opt-in)
      final bankPrefs = await loadBankSmsPrefs();
      if (bankPrefs.enabled && bankPrefs.enabledSenders.isNotEmpty) {
        final bankRaw = <Map<String, dynamic>>[];
        for (final sender in bankPrefs.enabledSenders) {
          try {
            final bankMsgs = await SmsChannel.getInboxSms(address: sender);
            final recentBank = bankMsgs.where(
              (m) => DateTime.fromMillisecondsSinceEpoch(m.date).isAfter(cutoff),
            );
            bankRaw.addAll(
              recentBank.map((m) => {'address': m.address, 'body': m.body, 'date': m.date}),
            );
          } catch (e) {
            AppLogger.sms('Background: could not read SMS from $sender — $e');
          }
        }
        if (bankRaw.isNotEmpty) {
          final bankTxns = BankSmsParser.parseAll(
            bankRaw, userId, bankPrefs.enabledSenders.toSet(),
          );
          for (final txn in bankTxns) {
            txn.periodId = FinancialPeriod.idForDate(txn.dateTime);
          }
          await IsarService.saveTransactions(bankTxns);
          AppLogger.sms('Background: saved ${bankTxns.length} bank transaction(s) to Isar');
        }
      }
    } catch (e, st) {
      AppLogger.error('📱 SMS', 'Background SMS check failed', e, st);
      // Errors also surface in Crashlytics via the zone in main.dart
    }
    return true;
  });
}

class BackgroundSmsService {
  static Future<void> initialize() async {
    if (kIsWeb) return;
    AppLogger.sms('Initializing WorkManager for background SMS');
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    AppLogger.sms('✅ WorkManager initialized');
  }

  static Future<void> schedulePeriodicSync(String userId) async {
    if (kIsWeb) return;
    AppLogger.sms('Scheduling periodic SMS sync (1h interval) for userId=$userId');
    await Workmanager().registerPeriodicTask(
      _kSmsCheckTask,
      _kSmsCheckTask,
      frequency: const Duration(hours: 1),
      inputData: {'userId': userId},
      constraints: Constraints(networkType: NetworkType.not_required),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
    AppLogger.sms('✅ Periodic SMS sync scheduled (keep-existing policy)');
  }

  static Future<void> cancel() async {
    if (kIsWeb) return;
    AppLogger.sms('Cancelling background SMS sync task');
    await Workmanager().cancelByUniqueName(_kSmsCheckTask);
    AppLogger.sms('✅ Background SMS sync cancelled');
  }
}
