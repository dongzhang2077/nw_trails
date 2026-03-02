import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nw_trails/core/models/landmark_category.dart';

class Landmark {
  const Landmark({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.description,
    required this.point,
  });

  final Point point;
  final String id;
  final String name;
  final LandmarkCategory category;
  final String address;
  final String description;
}
