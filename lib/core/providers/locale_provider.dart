import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_strings.dart';
import '../models/user_profile.dart';
import 'firebase_providers.dart';

final appLanguageProvider = Provider<AppLanguage>((ref) {
  return ref.watch(userProfileProvider).maybeWhen(
    data: (profile) => profile?.language ?? AppLanguage.english,
    orElse: () => AppLanguage.english,
  );
});

final appStringsProvider = Provider<AppStrings>((ref) {
  return AppStrings(ref.watch(appLanguageProvider));
});
