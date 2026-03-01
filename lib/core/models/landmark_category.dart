enum LandmarkCategory {
  historic,
  nature,
  food,
  culture,
}

extension LandmarkCategoryX on LandmarkCategory {
  String get label {
    switch (this) {
      case LandmarkCategory.historic:
        return 'Historic';
      case LandmarkCategory.nature:
        return 'Nature';
      case LandmarkCategory.food:
        return 'Food';
      case LandmarkCategory.culture:
        return 'Culture';
    }
  }
}
