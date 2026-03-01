class BadgeProgress {
  const BadgeProgress({
    required this.visitedCount,
    required this.totalLandmarks,
  });

  final int visitedCount;
  final int totalLandmarks;

  int get bronzeTarget => 5;
  int get silverTarget => 10;
  int get goldTarget => 15;

  bool get bronzeEarned => visitedCount >= bronzeTarget;
  bool get silverEarned => visitedCount >= silverTarget;
  bool get goldEarned => visitedCount >= goldTarget;

  double get completion {
    if (totalLandmarks == 0) {
      return 0;
    }
    return visitedCount / totalLandmarks;
  }

  String get nextBadgeHint {
    if (!bronzeEarned) {
      return 'Next badge: Bronze ($bronzeTarget)';
    }
    if (!silverEarned) {
      return 'Next badge: Silver ($silverTarget)';
    }
    if (!goldEarned) {
      return 'Next badge: Gold ($goldTarget)';
    }
    return 'All tier badges earned.';
  }
}
