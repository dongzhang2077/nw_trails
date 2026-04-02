class CheckInRecord {
  const CheckInRecord({
    required this.landmarkId,
    required this.checkedInAt,
    this.note,
    this.photoUrls = const <String>[],
  });

  final String landmarkId;
  final DateTime checkedInAt;
  final String? note;
  final List<String> photoUrls;
}
