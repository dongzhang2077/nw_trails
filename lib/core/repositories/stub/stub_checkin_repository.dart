import 'package:nw_trails/core/models/checkin_record.dart';
import 'package:nw_trails/core/repositories/checkin_repository.dart';

class StubCheckInRepository implements CheckInRepository {
  final List<CheckInRecord> _records = <CheckInRecord>[];

  @override
  List<CheckInRecord> getAll() {
    return List<CheckInRecord>.unmodifiable(_records);
  }

  @override
  bool hasCheckInForDate({
    required String landmarkId,
    required DateTime date,
  }) {
    for (final CheckInRecord record in _records) {
      if (record.landmarkId != landmarkId) {
        continue;
      }
      if (_isSameDate(record.checkedInAt, date)) {
        return true;
      }
    }
    return false;
  }

  @override
  void add(CheckInRecord record) {
    _records.add(record);
  }

  bool _isSameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}
