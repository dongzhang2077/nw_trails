import 'package:nw_trails/core/models/checkin_record.dart';

abstract class CheckInRepository {
  List<CheckInRecord> getAll();

  bool hasCheckInForDate({
    required String landmarkId,
    required DateTime date,
  });

  void add(CheckInRecord record);
}
