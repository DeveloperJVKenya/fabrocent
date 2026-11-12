import '../database/isar_service.dart';
import '../models/financial_period.dart';
import 'app_logger.dart';

class PeriodService {
  /// Ensures there is an active FinancialPeriod for the current calendar month.
  /// If a period for a previous month is still marked active, it is closed and
  /// a new period is created for the current month.
  static Future<FinancialPeriod> ensureCurrentPeriod(String userId) async {
    AppLogger.period('Checking active period for userId=$userId');
    final existing = await IsarService.getActivePeriod(userId);
    final now = DateTime.now();
    final currentId = FinancialPeriod.idForDate(now);

    if (existing == null) {
      AppLogger.period('No active period — creating new period $currentId');
      final period = FinancialPeriod.forMonth(now, userId);
      await IsarService.savePeriod(period);
      AppLogger.period('✅ Created period $currentId (${period.startDate} → ${period.endDate})');
      return period;
    }

    if (existing.periodId == currentId) {
      AppLogger.period('✅ Active period $currentId is current — no action needed');
      return existing;
    }

    // Month has rolled over — close the old period and open a new one
    AppLogger.period('Month rollover: closing ${existing.periodId} → opening $currentId');
    existing.isActive = false;
    existing.isClosed = true;
    await IsarService.savePeriod(existing);

    final newPeriod = FinancialPeriod.forMonth(now, userId);
    await IsarService.savePeriod(newPeriod);
    AppLogger.period('✅ Period rollover complete — now on $currentId');
    return newPeriod;
  }
}
