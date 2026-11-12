import 'package:flutter/widgets.dart';
import '../models/user_profile.dart';
import 'app_strings.dart';

class InheritedStrings extends InheritedWidget {
  final AppStrings strings;

  const InheritedStrings({
    super.key,
    required this.strings,
    required super.child,
  });

  static AppStrings of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<InheritedStrings>()
            ?.strings ??
        AppStrings(AppLanguage.english);
  }

  @override
  bool updateShouldNotify(InheritedStrings oldWidget) =>
      oldWidget.strings.language != strings.language;
}
