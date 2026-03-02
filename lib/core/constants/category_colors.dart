import 'package:flutter/material.dart';
import 'package:nw_trails/core/models/landmark_category.dart';

Color categoryColor(LandmarkCategory category) {
  return switch (category) {
    LandmarkCategory.historic => const Color(0xFF8B6914),
    LandmarkCategory.nature => const Color(0xFF2E7D32),
    LandmarkCategory.food => const Color(0xFFE65100),
    LandmarkCategory.culture => const Color(0xFF6A1B9A),
  };
}
