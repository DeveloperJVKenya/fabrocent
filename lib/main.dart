import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'core/services/app_logger.dart';
import 'core/services/background_sms_service.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialized on Android before this runs.
}

void main() async {
  AppLogger.startup('main() — step 1: WidgetsFlutterBinding');
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge (native only — no-op on web)
  if (!kIsWeb) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
    // Lock to portrait (web does not support this — skip to avoid hanging)
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  AppLogger.startup('step 2: Firebase.initializeApp — starting');
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    AppLogger.startup('step 3: Firebase.initializeApp — complete');
  } catch (e) {
    // On web hot-restart the Firebase JS SDK is already initialised in the
    // browser — the Flutter plugin may throw; catch and continue safely.
    AppLogger.warn('⚡ STARTUP', 'Firebase.initializeApp threw (hot-restart dup?): $e');
  }

  if (!kIsWeb) {
    // App Check — debug provider in dev, Play Integrity in production
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
    );

    // Local notifications (budget + transaction alerts)
    await NotificationService.initialize();

    // WorkManager (background SMS catch-up when app is killed)
    await BackgroundSmsService.initialize();

    // FCM — register background handler and request permission
    FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: false,
      sound: true,
    );

    // FCM foreground messages → show local notification
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      NotificationService.showFcmNotification(
        title: notification.title ?? 'FabroCent',
        body: notification.body ?? '',
      );
    });

    // Route all Flutter errors to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  AppLogger.startup('step 4: runApp — launching FabrocentApp');
  runApp(const ProviderScope(child: FabrocentApp()));
}
