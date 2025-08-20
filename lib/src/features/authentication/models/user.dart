class User {
  final int id;
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;
  final bool isActive;
  final bool isPremium;
  final DateTime? trialEndDate;
  final int monthlyScansUsed;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    required this.isActive,
    required this.isPremium,
    this.trialEndDate,
    required this.monthlyScansUsed,
    required this.createdAt,
  });

  // Constructor for Spendlee API response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      isActive: json['is_active'],
      isPremium: json['is_premium'],
      trialEndDate: json['trial_end_date'] != null
          ? DateTime.parse(json['trial_end_date'])
          : null,
      monthlyScansUsed: json['monthly_scans_used'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Constructor specifically for Spendlee API response (same as fromJson but more explicit)
  factory User.fromSpendleeJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'is_active': isActive,
      'is_premium': isPremium,
      'trial_end_date': trialEndDate?.toIso8601String(),
      'monthly_scans_used': monthlyScansUsed,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    } else {
      return username;
    }
  }

  bool get hasTrialExpired {
    if (trialEndDate == null) return false;
    return DateTime.now().isAfter(trialEndDate!);
  }

  User copyWith({
    int? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    bool? isActive,
    bool? isPremium,
    DateTime? trialEndDate,
    int? monthlyScansUsed,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isActive: isActive ?? this.isActive,
      isPremium: isPremium ?? this.isPremium,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      monthlyScansUsed: monthlyScansUsed ?? this.monthlyScansUsed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}