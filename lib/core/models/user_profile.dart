enum UserSegment {
  employed,
  selfEmployed,
  businessOwner,
  student,
  employer,
}

extension UserSegmentX on UserSegment {
  String get displayName {
    switch (this) {
      case UserSegment.employed:       return 'Employed';
      case UserSegment.selfEmployed:   return 'Self-Employed';
      case UserSegment.businessOwner:  return 'Business Owner';
      case UserSegment.student:        return 'Student';
      case UserSegment.employer:       return 'Employer';
    }
  }

  String get swahiliName {
    switch (this) {
      case UserSegment.employed:       return 'Mfanyikazi';
      case UserSegment.selfEmployed:   return 'Kujitegemea';
      case UserSegment.businessOwner:  return 'Mfanyabiashara';
      case UserSegment.student:        return 'Mwanafunzi';
      case UserSegment.employer:       return 'Mwajiri';
    }
  }

  String get description {
    switch (this) {
      case UserSegment.employed:       return 'I receive a regular salary';
      case UserSegment.selfEmployed:   return 'I work for myself / freelance';
      case UserSegment.businessOwner:  return 'I own a business (Pochi/Till/Paybill)';
      case UserSegment.student:        return 'I\'m a student';
      case UserSegment.employer:       return 'I employ others and pay salaries';
    }
  }

  bool get hasBusinessAccount =>
      this == UserSegment.businessOwner || this == UserSegment.employer;
}

enum AppLanguage { english, swahili }

class UserProfile {
  final String uid;
  final String phoneNumber;
  final String? displayName;
  final UserSegment segment;
  final AppLanguage language;
  final bool hasPochi;
  final bool hasTill;
  final bool hasPaybill;
  final int periodStartDay; // day of month the financial period starts (default 1)
  final bool onboardingComplete;
  final bool biometricEnabled;
  final String? photoUrl;
  final DateTime createdAt;

  const UserProfile({
    required this.uid,
    required this.phoneNumber,
    this.displayName,
    required this.segment,
    required this.language,
    required this.hasPochi,
    required this.hasTill,
    required this.hasPaybill,
    required this.periodStartDay,
    required this.onboardingComplete,
    required this.biometricEnabled,
    this.photoUrl,
    required this.createdAt,
  });

  UserProfile copyWith({
    String? displayName,
    String? phoneNumber,
    UserSegment? segment,
    AppLanguage? language,
    bool? hasPochi,
    bool? hasTill,
    bool? hasPaybill,
    int? periodStartDay,
    bool? onboardingComplete,
    bool? biometricEnabled,
    String? photoUrl,
  }) {
    return UserProfile(
      uid: uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      segment: segment ?? this.segment,
      language: language ?? this.language,
      hasPochi: hasPochi ?? this.hasPochi,
      hasTill: hasTill ?? this.hasTill,
      hasPaybill: hasPaybill ?? this.hasPaybill,
      periodStartDay: periodStartDay ?? this.periodStartDay,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'uid': uid,
    'phoneNumber': phoneNumber,
    'displayName': displayName,
    'segment': segment.name,
    'language': language.name,
    'hasPochi': hasPochi,
    'hasTill': hasTill,
    'hasPaybill': hasPaybill,
    'periodStartDay': periodStartDay,
    'onboardingComplete': onboardingComplete,
    'biometricEnabled': biometricEnabled,
    'photoUrl': photoUrl,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserProfile.fromFirestore(Map<String, dynamic> data) => UserProfile(
    uid: data['uid'] as String,
    phoneNumber: data['phoneNumber'] as String,
    displayName: data['displayName'] as String?,
    segment: UserSegment.values.firstWhere(
      (s) => s.name == data['segment'],
      orElse: () => UserSegment.employed,
    ),
    language: AppLanguage.values.firstWhere(
      (l) => l.name == data['language'],
      orElse: () => AppLanguage.english,
    ),
    hasPochi: (data['hasPochi'] as bool?) ?? false,
    hasTill: (data['hasTill'] as bool?) ?? false,
    hasPaybill: (data['hasPaybill'] as bool?) ?? false,
    periodStartDay: (data['periodStartDay'] as int?) ?? 1,
    onboardingComplete: (data['onboardingComplete'] as bool?) ?? false,
    biometricEnabled: (data['biometricEnabled'] as bool?) ?? false,
    photoUrl: data['photoUrl'] as String?,
    createdAt: DateTime.parse(data['createdAt'] as String),
  );
}
