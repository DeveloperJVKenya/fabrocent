import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/app_logger.dart';

// ─── Firebase singletons ──────────────────────────────────────────────────

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final remoteConfigProvider = Provider<FirebaseRemoteConfig>(
  (ref) => FirebaseRemoteConfig.instance,
);

final storageProvider = Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

final fcmTokenProvider = FutureProvider<String?>((ref) async {
  return FirebaseMessaging.instance.getToken();
});

// ─── Auth state ───────────────────────────────────────────────────────────

final authStateProvider = StreamProvider<User?>((ref) {
  AppLogger.auth('Creating auth state subscription');

  // Emit null after 5s if Firebase Auth hasn't responded (web IndexedDB lag).
  AppLogger.auth('authStateProvider: subscribing to authStateChanges()');
  final controller = StreamController<User?>();
  bool firstEventReceived = false;

  final timer = Timer(const Duration(seconds: 5), () {
    if (!firstEventReceived && !controller.isClosed) {
      AppLogger.warn(
        '🔐 AUTH',
        'Auth state timed out after 5s — emitting null to unblock router',
      );
      controller.add(null);
    }
  });

  final sub = ref.watch(firebaseAuthProvider).authStateChanges().listen(
    (user) {
      firstEventReceived = true;
      timer.cancel();
      if (controller.isClosed) return;
      AppLogger.auth('authStateProvider: event received — user=${user?.uid ?? "null"}');
      if (user == null) {
        AppLogger.auth('Auth state changed → signed out');
      } else {
        AppLogger.auth('✅ Auth state changed → signed in uid=${user.uid}');
      }
      controller.add(user);
    },
    onError: (Object e, StackTrace st) {
      AppLogger.error('🔐 AUTH', 'Auth state stream error', e, st);
      if (!controller.isClosed) controller.addError(e, st);
    },
  );

  ref.onDispose(() {
    timer.cancel();
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

// ─── User profile ─────────────────────────────────────────────────────────

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    AppLogger.auth('No user — profile stream emitting null');
    return Stream.value(null);
  }

  AppLogger.auth('Creating Firestore profile subscription for uid=${user.uid}');
  final firestore = ref.watch(firestoreProvider);

  // One-shot web-hang fix: emit null ONCE if Firestore hasn't responded in 7s.
  // Uses a Timer+StreamController so the timeout fires only once — never repeatedly
  // after subsequent quiet periods (which would re-null the profile after onboarding).
  final controller = StreamController<UserProfile?>();
  bool firstEventReceived = false;

  final timer = Timer(const Duration(seconds: 7), () {
    if (!firstEventReceived && !controller.isClosed) {
      AppLogger.warn(
        '🔐 AUTH',
        'Profile stream timed out after 7s — emitting null to unblock router '
        '(stream continues; will update when Firestore responds)',
      );
      controller.add(null);
    }
  });

  final sub = firestore
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .listen(
    (snap) {
      firstEventReceived = true;
      timer.cancel();
      if (controller.isClosed) return;
      if (!snap.exists || snap.data() == null) {
        AppLogger.auth('Profile snapshot — no document for uid=${user.uid}');
        controller.add(null);
      } else {
        final profile = UserProfile.fromFirestore(snap.data()!);
        AppLogger.auth(
          '📥 Profile snapshot received — '
          'name=${profile.displayName} segment=${profile.segment.name} '
          'onboarded=${profile.onboardingComplete}',
        );
        controller.add(profile);
      }
    },
    onError: (Object e, StackTrace st) {
      AppLogger.error('🔐 AUTH', 'Profile stream error', e, st);
      if (!controller.isClosed) controller.addError(e, st);
    },
    onDone: () { if (!controller.isClosed) controller.close(); },
  );

  ref.onDispose(() {
    timer.cancel();
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

// ─── Remote config helpers ────────────────────────────────────────────────

final paybillRemoteDirectoryProvider = Provider<Map<String, String>>((ref) {
  final rc = ref.watch(remoteConfigProvider);
  // Returns a JSON string stored in Remote Config as "paybill_directory"
  // Format: {"888880":"Kenya Power","400222":"NHIF", ...}
  try {
    final raw = rc.getString('paybill_directory');
    if (raw.isEmpty) return {};
    // Simple key-value parsing without json_serializable dependency
    final cleaned = raw.replaceAll('{', '').replaceAll('}', '').replaceAll('"', '');
    final entries = cleaned.split(',');
    return Map.fromEntries(
      entries.where((e) => e.contains(':')).map((e) {
        final parts = e.split(':');
        return MapEntry(parts[0].trim(), parts[1].trim());
      }),
    );
  } catch (_) {
    return {};
  }
});

// ─── Firestore user profile writes ───────────────────────────────────────

class UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepository(this._firestore);

  Future<void> save(UserProfile profile) async {
    AppLogger.db('UserProfileRepository: Saving profile uid=${profile.uid}');
    try {
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .set(profile.toFirestore(), SetOptions(merge: true));
      AppLogger.db('✅ UserProfileRepository: Profile saved uid=${profile.uid}');
    } catch (e, st) {
      AppLogger.error('💾 DB', 'UserProfileRepository: Failed to save profile', e, st);
      rethrow;
    }
  }

  Future<UserProfile?> get(String uid) async {
    AppLogger.db('UserProfileRepository: Fetching profile uid=$uid');
    final snap = await _firestore.collection('users').doc(uid).get();
    if (!snap.exists || snap.data() == null) {
      AppLogger.db('UserProfileRepository: No profile found for uid=$uid');
      return null;
    }
    AppLogger.db('✅ UserProfileRepository: Profile fetched uid=$uid');
    return UserProfile.fromFirestore(snap.data()!);
  }
}

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(ref.watch(firestoreProvider));
});
