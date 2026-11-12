import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // needed for notificationServiceProvider
import 'app_logger.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _budgetChannelId = 'budget_alerts';
  static const _txnChannelId = 'transactions';

  static Future<void> initialize() async {
    AppLogger.notif('Initializing local notification plugin');
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);

    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImpl?.createNotificationChannel(const AndroidNotificationChannel(
      _budgetChannelId,
      'Budget Alerts',
      description: 'Alerts when you approach or exceed your spending budget',
      importance: Importance.high,
    ));

    await androidImpl?.createNotificationChannel(const AndroidNotificationChannel(
      _txnChannelId,
      'New Transactions',
      description: 'Alerts for new M-Pesa transactions',
      importance: Importance.defaultImportance,
    ));
    AppLogger.notif('✅ Notification channels created (budget_alerts, transactions)');
  }

  static Future<void> showBudgetAlert({
    required String categoryName,
    required double usagePercent,
    required double spentAmount,
    required double allocatedAmount,
  }) async {
    AppLogger.notif('Budget alert: $categoryName at ${usagePercent.toStringAsFixed(0)}%');
    final isOver = usagePercent >= 100;
    final title = isOver
        ? 'Budget exceeded: $categoryName'
        : '80% budget reached: $categoryName';
    final body =
        'Spent Ksh ${spentAmount.toStringAsFixed(0)} of Ksh ${allocatedAmount.toStringAsFixed(0)}';

    await _plugin.show(
      categoryName.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _budgetChannelId,
          'Budget Alerts',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  static Future<void> showNewTransactionAlert({
    required String description,
    required double amount,
    required bool isCredit,
  }) async {
    final title = isCredit ? 'Money Received' : 'Payment Made';
    final body = '$description — Ksh ${amount.toStringAsFixed(0)}';

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _txnChannelId,
          'New Transactions',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  static Future<void> showFcmNotification({
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      title.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _txnChannelId,
          'New Transactions',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}

final notificationServiceProvider =
    Provider<NotificationService>((_) => NotificationService());
