import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'core/services/background_sms_service.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 5,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  _logger.d('📡 main: FCM background message received — ${message.notification?.title}');
}

void main() async {
  _logger.i('🚀 FabroCent: Starting up (platform: ${kIsWeb ? "web" : "native"}, debug: $kDebugMode)');
  WidgetsFlutterBinding.ensureInitialized();
  _logger.d('🏗️ main: Flutter binding initialized');

  // Edge-to-edge: status bar and nav bar fully transparent
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  // Lock to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  _logger.d('🏗️ main: UI mode and orientation configured');

  _logger.i('🔥 main: Initializing Firebase');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _logger.i('✅ main: Firebase initialized successfully');
  } catch (e, st) {
    _logger.e('❌ main: Firebase initialization failed', error: e, stackTrace: st);
    rethrow;
  }

  if (!kIsWeb) {
    // App Check — debug provider in dev, Play Integrity in production
    _logger.d('🔥 main: Activating App Check (${kDebugMode ? "debug" : "Play Integrity"})');
    try {
      await FirebaseAppCheck.instance.activate(
        providerAndroid: kDebugMode
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),
      );
      _logger.i('✅ main: App Check activated');
    } catch (e, st) {
      _logger.w('⚠️ main: App Check activation failed — continuing without it', error: e, stackTrace: st);
    }

    // Local notifications (budget + transaction alerts)
    _logger.d('🏗️ main: Initializing local notifications');
    try {
      await NotificationService.initialize();
      _logger.i('✅ main: Local notifications initialized');
    } catch (e, st) {
      _logger.e('❌ main: Notification init failed', error: e, stackTrace: st);
    }

    // WorkManager (background SMS catch-up when app is killed)
    _logger.d('🏗️ main: Initializing background SMS service');
    try {
      await BackgroundSmsService.initialize();
      _logger.i('✅ main: Background SMS service initialized');
    } catch (e, st) {
      _logger.e('❌ main: Background SMS init failed', error: e, stackTrace: st);
    }

    // FCM — register background handler and request permission
    _logger.d('📡 main: Registering FCM background handler');
    FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);

    _logger.d('📡 main: Requesting FCM permissions');
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: false,
        sound: true,
      );
      _logger.i('✅ main: FCM permissions — ${settings.authorizationStatus}');
    } catch (e, st) {
      _logger.w('⚠️ main: FCM permission request failed', error: e, stackTrace: st);
    }

    // FCM foreground messages → show local notification
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _logger.i('📱 main: FCM foreground message — "${notification.title}"');
      NotificationService.showFcmNotification(
        title: notification.title ?? 'FabroCent',
        body: notification.body ?? '',
      );
    });

    // Route all Flutter errors to Crashlytics
    _logger.d('🔥 main: Routing Flutter errors to Crashlytics');
    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      _logger.e('❌ main: Unhandled platform error', error: error, stackTrace: stack);
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } else {
    _logger.i('🌐 main: Web platform — skipping native-only services');
  }

  _logger.i('✅ main: Startup complete — launching app UI');
  runApp(const ProviderScope(child: FabrocentApp()));
}
