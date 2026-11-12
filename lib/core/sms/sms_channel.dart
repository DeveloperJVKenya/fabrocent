import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../services/app_logger.dart';

class SmsMessage {
  final String address;
  final String body;
  final int date;

  const SmsMessage({
    required this.address,
    required this.body,
    required this.date,
  });
}

class SmsChannel {
  static const _method = MethodChannel('com.fabrocent/sms');
  static const _event = EventChannel('com.fabrocent/sms_stream');

  static Future<List<SmsMessage>> getInboxSms({String? address}) async {
    if (kIsWeb) {
      AppLogger.sms('getInboxSms: web — returning empty list');
      return [];
    }
    AppLogger.sms('getInboxSms: reading inbox${address != null ? " filter=$address" : ""}');
    try {
      final List<dynamic> raw =
          await _method.invokeMethod('getInboxSms', {'address': address});
      final messages = raw.map((item) {
        final m = Map<String, dynamic>.from(item as Map);
        return SmsMessage(
          address: (m['address'] as String?) ?? '',
          body: (m['body'] as String?) ?? '',
          date: (m['date'] as int?) ?? 0,
        );
      }).toList();
      AppLogger.sms('getInboxSms: ✅ ${messages.length} messages read from inbox');
      return messages;
    } catch (e, st) {
      AppLogger.error('SMS', 'getInboxSms failed', e, st);
      rethrow;
    }
  }

  static Stream<SmsMessage> get incomingSmsStream {
    if (kIsWeb) {
      AppLogger.sms('incomingSmsStream: web — returning empty stream');
      return const Stream.empty();
    }
    AppLogger.sms('incomingSmsStream: opening event channel');
    return _event.receiveBroadcastStream().map((data) {
      final m = Map<String, dynamic>.from(data as Map);
      final msg = SmsMessage(
        address: (m['address'] as String?) ?? '',
        body: (m['body'] as String?) ?? '',
        date: (m['date'] as int?) ?? 0,
      );
      AppLogger.sms('incomingSmsStream: 📥 SMS from ${msg.address}');
      return msg;
    });
  }
}
