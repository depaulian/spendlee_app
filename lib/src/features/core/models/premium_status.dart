class PremiumStatus {
  final bool isPremium;
  final bool trialActive;
  final String? trialEndDate;
  final int monthlyScansUsed;
  final int freeScansRemaining;
  final bool unlimitedScans;
  final bool advancedReports;
  final bool exportFunctionality;
  final bool premiumSupport;

  PremiumStatus({
    required this.isPremium,
    required this.trialActive,
    this.trialEndDate,
    required this.monthlyScansUsed,
    required this.freeScansRemaining,
    required this.unlimitedScans,
    required this.advancedReports,
    required this.exportFunctionality,
    required this.premiumSupport,
  });

  factory PremiumStatus.fromJson(Map<String, dynamic> json) {
    return PremiumStatus(
      isPremium: json['is_premium'] ?? false,
      trialActive: json['trial_active'] ?? false,
      trialEndDate: json['trial_end_date'],
      monthlyScansUsed: json['monthly_scans_used'] ?? 0,
      freeScansRemaining: json['free_scans_remaining'] ?? 0,
      unlimitedScans: json['unlimited_scans'] ?? false,
      advancedReports: json['advanced_reports'] ?? false,
      exportFunctionality: json['export_functionality'] ?? false,
      premiumSupport: json['premium_support'] ?? false,
    );
  }
}