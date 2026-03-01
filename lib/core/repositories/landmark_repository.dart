import 'package:nw_trails/core/models/landmark.dart';

abstract class LandmarkRepository {
  List<Landmark> getAll();
}
