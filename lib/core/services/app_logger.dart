import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

/// Central structured logger for fabrocent.
///
/// Uses dart:developer (built-in SDK — no pubspec entry needed).
/// Output is debug-only and visible in the Flutter DevTools Logging tab
/// and in the terminal when running `flutter run`.
///
/// Level mapping (dart:developer convention):
///   800 = INFO  |  900 = WARNING  |  1000 = SEVERE/ERROR
class AppLogger {
  AppLogger._();

  // ─── Tagged info logs ──────────────────────────────────────────────────────

  static void startup(String msg) => _log('⚡ STARTUP', msg);
  static void auth(String msg)    => _log('🔐 AUTH',    msg);
  static void router(String msg)  => _log('🗺  ROUTER',  msg);
  static void db(String msg)      => _log('💾 DB',      msg);
  static void sync(String msg)    => _log('☁  SYNC',    msg);
  static void sms(String msg)     => _log('📱 SMS',     msg);
  static void ai(String msg)      => _log('🤖 AI',      msg);
  static void config(String msg)  => _log('⚙  CONFIG',  msg);
  static void notif(String msg)   => _log('🔔 NOTIF',   msg);
  static void dash(String msg)    => _log('📊 DASH',    msg);
  static void budget(String msg)  => _log('💰 BUDGET',  msg);
  static void web(String msg)     => _log('🌐 WEB',     msg);
  static void period(String msg)  => _log('📅 PERIOD',  msg);
  static void ui(String msg)      => _log('🖼  UI',      msg);

  // ─── Warnings ─────────────────────────────────────────────────────────────

  static void warn(String tag, String msg, [Object? err, StackTrace? st]) =>
      _log(tag, '⚠️  $msg', level: 900, error: err, stackTrace: st);

  // ─── Errors ───────────────────────────────────────────────────────────────

  static void error(String tag, String msg,
      [Object? err, StackTrace? st]) =>
      _log(tag, '❌ $msg', level: 1000, error: err, stackTrace: st);

  // ─── Internal ─────────────────────────────────────────────────────────────

  static void _log(
    String tag,
    String msg, {
    int level = 800,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;
    dev.log(msg, name: tag, level: level,
        error: error, stackTrace: stackTrace);
  }
}
