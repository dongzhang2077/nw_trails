class CheckInRecord {
  const CheckInRecord({
    required this.landmarkId,
    required this.checkedInAt,
    this.note,
  });

  final String landmarkId;
  final DateTime checkedInAt;
  final String? note;
}
