import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sms/known_banks.dart';

// ─── Font size ────────────────────────────────────────────────────────────────

enum AppFontSize { small, normal, large, xlarge }

extension AppFontSizeX on AppFontSize {
  double get scale => switch (this) {
    AppFontSize.small  => 0.85,
    AppFontSize.normal => 1.0,
    AppFontSize.large  => 1.15,
    AppFontSize.xlarge => 1.3,
  };
  String get label => switch (this) {
    AppFontSize.small  => 'Small',
    AppFontSize.normal => 'Normal',
    AppFontSize.large  => 'Large',
    AppFontSize.xlarge => 'X-Large',
  };
}

class FontSizeNotifier extends AsyncNotifier<AppFontSize> {
  static const _key = 'fabrocent_font_size';

  @override
  Future<AppFontSize> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    return AppFontSize.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => AppFontSize.normal,
    );
  }

  Future<void> setSize(AppFontSize size) async {
    state = AsyncData(size);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, size.name);
  }
}

final fontSizeProvider =
    AsyncNotifierProvider<FontSizeNotifier, AppFontSize>(FontSizeNotifier.new);

// ─── Notification preferences ─────────────────────────────────────────────────

class NotificationPrefs {
  final bool budgetAlerts;
  final bool transactionAlerts;
  final bool weeklySummary;

  const NotificationPrefs({
    this.budgetAlerts = true,
    this.transactionAlerts = true,
    this.weeklySummary = true,
  });

  NotificationPrefs copyWith({
    bool? budgetAlerts,
    bool? transactionAlerts,
    bool? weeklySummary,
  }) => NotificationPrefs(
    budgetAlerts: budgetAlerts ?? this.budgetAlerts,
    transactionAlerts: transactionAlerts ?? this.transactionAlerts,
    weeklySummary: weeklySummary ?? this.weeklySummary,
  );
}

class NotificationPrefsNotifier extends AsyncNotifier<NotificationPrefs> {
  static const _kBudget = 'notif_budget_alerts';
  static const _kTxn    = 'notif_txn_alerts';
  static const _kWeekly = 'notif_weekly_summary';

  @override
  Future<NotificationPrefs> build() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationPrefs(
      budgetAlerts:      prefs.getBool(_kBudget) ?? true,
      transactionAlerts: prefs.getBool(_kTxn)    ?? true,
      weeklySummary:     prefs.getBool(_kWeekly)  ?? true,
    );
  }

  Future<void> setBudgetAlerts(bool v) async {
    final cur = state.valueOrNull ?? const NotificationPrefs();
    state = AsyncData(cur.copyWith(budgetAlerts: v));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBudget, v);
  }

  Future<void> setTransactionAlerts(bool v) async {
    final cur = state.valueOrNull ?? const NotificationPrefs();
    state = AsyncData(cur.copyWith(transactionAlerts: v));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTxn, v);
  }

  Future<void> setWeeklySummary(bool v) async {
    final cur = state.valueOrNull ?? const NotificationPrefs();
    state = AsyncData(cur.copyWith(weeklySummary: v));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWeekly, v);
  }
}

final notificationPrefsProvider =
    AsyncNotifierProvider<NotificationPrefsNotifier, NotificationPrefs>(
      NotificationPrefsNotifier.new,
    );

// ─── Bank SMS settings ────────────────────────────────────────────────────────

class BankSmsPrefs {
  final bool enabled;
  final Set<String> enabledPrefKeys; // set of KenyanBank.prefKey values

  const BankSmsPrefs({this.enabled = false, this.enabledPrefKeys = const {}});

  BankSmsPrefs copyWith({bool? enabled, Set<String>? enabledPrefKeys}) =>
      BankSmsPrefs(
        enabled: enabled ?? this.enabled,
        enabledPrefKeys: enabledPrefKeys ?? this.enabledPrefKeys,
      );

  /// All sender addresses that are enabled (for use in native SMS fetch).
  List<String> get enabledSenders => knownKenyanBanks
      .where((b) => enabledPrefKeys.contains(b.prefKey))
      .expand((b) => b.senders)
      .toList();
}

class BankSmsNotifier extends AsyncNotifier<BankSmsPrefs> {
  static const _kEnabled = 'bank_sms_enabled';
  static const _kKeys    = 'bank_sms_pref_keys'; // JSON list

  @override
  Future<BankSmsPrefs> build() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_kEnabled) ?? false;
    final raw = prefs.getString(_kKeys);
    final keys = raw != null
        ? Set<String>.from(jsonDecode(raw) as List)
        : <String>{};
    return BankSmsPrefs(enabled: enabled, enabledPrefKeys: keys);
  }

  Future<void> setEnabled(bool v) async {
    final cur = state.valueOrNull ?? const BankSmsPrefs();
    state = AsyncData(cur.copyWith(enabled: v));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEnabled, v);
  }

  Future<void> toggleBank(String prefKey, bool v) async {
    final cur = state.valueOrNull ?? const BankSmsPrefs();
    final keys = Set<String>.from(cur.enabledPrefKeys);
    if (v) { keys.add(prefKey); } else { keys.remove(prefKey); }
    state = AsyncData(cur.copyWith(enabledPrefKeys: keys));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKeys, jsonEncode(keys.toList()));
  }
}

final bankSmsProvider =
    AsyncNotifierProvider<BankSmsNotifier, BankSmsPrefs>(BankSmsNotifier.new);

// ─── Public read helpers (usable in background tasks without Riverpod) ────────

Future<bool> isBudgetAlertsEnabled() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(NotificationPrefsNotifier._kBudget) ?? true;
}

Future<bool> isTransactionAlertsEnabled() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(NotificationPrefsNotifier._kTxn) ?? true;
}

Future<BankSmsPrefs> loadBankSmsPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final enabled = prefs.getBool(BankSmsNotifier._kEnabled) ?? false;
  final raw = prefs.getString(BankSmsNotifier._kKeys);
  final keys = raw != null
      ? Set<String>.from(jsonDecode(raw) as List)
      : <String>{};
  return BankSmsPrefs(enabled: enabled, enabledPrefKeys: keys);
}

// ─── Bold text ────────────────────────────────────────────────────────────────

class BoldTextNotifier extends AsyncNotifier<bool> {
  static const _key = 'fabrocent_bold_text';

  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> toggle(bool v) async {
    state = AsyncData(v);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, v);
  }
}

final boldTextProvider =
    AsyncNotifierProvider<BoldTextNotifier, bool>(BoldTextNotifier.new);

// ─── Reduce motion ────────────────────────────────────────────────────────────

class ReduceMotionNotifier extends AsyncNotifier<bool> {
  static const _key = 'fabrocent_reduce_motion';

  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> toggle(bool v) async {
    state = AsyncData(v);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, v);
  }
}

final reduceMotionProvider =
    AsyncNotifierProvider<ReduceMotionNotifier, bool>(ReduceMotionNotifier.new);
