class RoutePlan {
  const RoutePlan({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.durationMinutes,
    required this.difficulty,
    required this.landmarkIds,
  });

  final String id;
  final String name;
  final double distanceKm;
  final int durationMinutes;
  final String difficulty;
  final List<String> landmarkIds;
}
