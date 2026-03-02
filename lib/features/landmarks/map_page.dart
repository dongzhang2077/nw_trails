import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/core/constants/category_colors.dart';
import 'package:nw_trails/core/models/landmark.dart';
import 'package:nw_trails/core/models/landmark_category.dart';
import 'package:nw_trails/features/landmarks/landmark_detail_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String? _selectedLandmarkId;
  final GlobalKey _selectedPreviewKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectLandmark(Landmark landmark, {bool fromExplore = false}) {
    setState(() {
      _selectedLandmarkId = landmark.id;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      if (fromExplore) {
        final double previewZoneOffset = 620;
        final double clampedOffset = previewZoneOffset.clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        );
        _scrollController.animateTo(
          clampedOffset,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
        );
      }

      final BuildContext? targetContext = _selectedPreviewKey.currentContext;
      if (targetContext == null) {
        return;
      }

      Future<void>.delayed(const Duration(milliseconds: 80), () {
        if (!mounted) {
          return;
        }
        Scrollable.ensureVisible(
          targetContext,
          alignment: fromExplore ? 0.12 : 0.08,
          duration: const Duration(milliseconds: 460),
          curve: Curves.easeOutCubic,
        );
      });
    });

    if (fromExplore) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Now previewing ${landmark.name} on map.'),
          duration: const Duration(milliseconds: 900),
        ),
      );
    }
  }

  Alignment _pinAlignmentForLandmark(String landmarkId) {
    return switch (landmarkId) {
      'l1' => const Alignment(-0.62, -0.62),
      'l2' => const Alignment(-0.18, -0.56),
      'l3' => const Alignment(0.02, -0.42),
      'l4' => const Alignment(-0.44, -0.28),
      'l5' => const Alignment(-0.70, 0.18),
      'l6' => const Alignment(-0.36, 0.38),
      'l7' => const Alignment(0.18, 0.22),
      'l8' => const Alignment(0.46, 0.02),
      'l9' => const Alignment(0.58, 0.16),
      'l10' => const Alignment(0.52, 0.34),
      'l11' => const Alignment(0.32, 0.54),
      'l12' => const Alignment(-0.54, 0.60),
      'l13' => const Alignment(-0.16, 0.66),
      'l14' => const Alignment(0.42, -0.10),
      'l15' => const Alignment(0.66, -0.32),
      _ => Alignment.center,
    };
  }

  int _mockDistanceMeters(String landmarkId) {
    final int seed = int.tryParse(landmarkId.replaceFirst('l', '')) ?? 1;
    return 70 + (seed * 13);
  }

  int _mockCheckInCount(String landmarkId, int realCheckInCount) {
    final int seed = int.tryParse(landmarkId.replaceFirst('l', '')) ?? 1;
    return 120 + seed * 11 + realCheckInCount;
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final activeRoute = appState.activeRoute;
    final List<Landmark> landmarks = appState.filteredLandmarks;

    Landmark? selectedLandmark;
    for (final Landmark landmark in landmarks) {
      if (landmark.id == _selectedLandmarkId) {
        selectedLandmark = landmark;
        break;
      }
    }
    selectedLandmark ??= landmarks.isEmpty ? null : landmarks.first;

    final List<Landmark> highlightedLandmarks = landmarks.where((landmark) {
      return landmark.id != selectedLandmark?.id;
    }).take(5).toList(growable: false);

    final Set<String> alreadyShownIds = <String>{
      if (selectedLandmark != null) selectedLandmark.id,
      ...highlightedLandmarks.map((landmark) => landmark.id),
    };
    final List<Landmark> remainingLandmarks = landmarks.where((landmark) {
      return !alreadyShownIds.contains(landmark.id);
    }).toList(growable: false);

    return SafeArea(
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'NW Trails',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Discover landmarks and open details to check in.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: appState.selectedCategory == null,
                    onSelected: (_) => appState.setCategory(null),
                  ),
                ),
                for (final LandmarkCategory category in LandmarkCategory.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category.label),
                      selected: appState.selectedCategory == category,
                      selectedColor: categoryColor(category),
                      labelStyle: TextStyle(
                        color: appState.selectedCategory == category
                            ? Colors.white
                            : categoryColor(category),
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide(color: categoryColor(category)),
                      onSelected: (_) => appState.setCategory(category),
                    ),
                  ),
              ],
            ),
          ),
          if (activeRoute != null) ...<Widget>[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.route,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Active route: ${activeRoute.name}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          _MapCanvas(
            landmarks: landmarks,
            selectedLandmarkId: selectedLandmark?.id,
            pinAlignmentForLandmark: _pinAlignmentForLandmark,
            onLandmarkTap: (Landmark landmark) {
              _selectLandmark(landmark);
            },
          ),
          const SizedBox(height: 12),
          if (selectedLandmark != null)
            Container(
              key: _selectedPreviewKey,
              child: Builder(
                builder: (context) {
                  final Landmark currentLandmark = selectedLandmark!;
                  return _MapPreviewCard(
                    landmark: currentLandmark,
                    distanceMeters: _mockDistanceMeters(currentLandmark.id),
                    checkInCount: _mockCheckInCount(
                      currentLandmark.id,
                      appState.checkInRecords.where((record) {
                        return record.landmarkId == currentLandmark.id;
                      }).length,
                    ),
                  );
                },
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'No landmarks in this category. Pick another filter to explore.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          if (highlightedLandmarks.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              'Popular around you',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final Landmark landmark in highlightedLandmarks) ...<Widget>[
              _MapPreviewCard(
                landmark: landmark,
                distanceMeters: _mockDistanceMeters(landmark.id),
                checkInCount: _mockCheckInCount(
                  landmark.id,
                  appState.checkInRecords.where((record) {
                    return record.landmarkId == landmark.id;
                  }).length,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
          if (remainingLandmarks.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              'Explore other landmarks',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 118,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: remainingLandmarks.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final Landmark landmark = remainingLandmarks[index];
                  final bool isSelected = landmark.id == selectedLandmark?.id;
                  return _LandmarkSelectorTile(
                    landmark: landmark,
                    isSelected: isSelected,
                    onTap: () {
                      _selectLandmark(landmark, fromExplore: true);
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MapCanvas extends StatelessWidget {
  const _MapCanvas({
    super.key,
    required this.landmarks,
    required this.selectedLandmarkId,
    required this.pinAlignmentForLandmark,
    required this.onLandmarkTap,
  });

  final List<Landmark> landmarks;
  final String? selectedLandmarkId;
  final Alignment Function(String landmarkId) pinAlignmentForLandmark;
  final ValueChanged<Landmark> onLandmarkTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 470,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB5D9E7)),
        color: const Color(0xFFD6EBF3),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xFFCFE6F0), Color(0xFFBEDCE9)],
                ),
              ),
            ),
          ),
          Positioned(
            left: -40,
            right: -40,
            top: 170,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                height: 74,
                color: const Color(0xFF9FCCE1),
              ),
            ),
          ),
          for (final Landmark landmark in landmarks)
            Align(
              alignment: pinAlignmentForLandmark(landmark.id),
              child: GestureDetector(
                onTap: () => onLandmarkTap(landmark),
                child: _LandmarkPin(
                  color: categoryColor(landmark.category),
                  isSelected: landmark.id == selectedLandmarkId,
                ),
              ),
            ),
          const Align(
            alignment: Alignment(0.06, 0.30),
            child: _UserDot(),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'New Westminster (wireframe placeholder map)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPreviewCard extends StatelessWidget {
  const _MapPreviewCard({
    required this.landmark,
    required this.distanceMeters,
    required this.checkInCount,
  });

  final Landmark landmark;
  final int distanceMeters;
  final int checkInCount;

  @override
  Widget build(BuildContext context) {
    final Color categoryTagColor = categoryColor(landmark.category);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  landmark.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported_outlined),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              landmark.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                Chip(
                  label: Text(landmark.category.label),
                  side: BorderSide.none,
                  backgroundColor: categoryTagColor.withOpacity(0.14),
                  labelStyle: TextStyle(
                    color: categoryTagColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Chip(
                  avatar: const Icon(Icons.place_outlined, size: 16),
                  label: Text(landmark.address),
                  side: BorderSide.none,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              landmark.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.star, color: Colors.amber.shade700, size: 16),
                    const SizedBox(width: 4),
                    Text(landmark.rating.toStringAsFixed(1)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.verified,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    const Text('Check-in ready'),
                  ],
                ),
                Text('Distance ${distanceMeters}m'),
                Text('Check-ins $checkInCount'),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => LandmarkDetailPage(landmarkId: landmark.id),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('View details'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LandmarkPin extends StatelessWidget {
  const _LandmarkPin({required this.color, required this.isSelected});

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final double size = isSelected ? 26 : 16;
    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      scale: isSelected ? 1.1 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.24 : 0.12),
              blurRadius: isSelected ? 12 : 4,
              offset: const Offset(0, 2),
            ),
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.45),
                blurRadius: 16,
                spreadRadius: 3,
              ),
          ],
        ),
        child: isSelected
            ? const Icon(Icons.place, size: 13, color: Colors.white)
            : null,
      ),
    );
  }
}

class _UserDot extends StatelessWidget {
  const _UserDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: const Color(0xFF4D8BFF),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

class _LandmarkSelectorTile extends StatelessWidget {
  const _LandmarkSelectorTile({
    required this.landmark,
    required this.isSelected,
    required this.onTap,
  });

  final Landmark landmark;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = categoryColor(landmark.category);

    return SizedBox(
      width: 210,
      child: Card(
        color: isSelected ? color.withOpacity(0.1) : null,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  landmark.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  '${landmark.category.label} | ${landmark.rating.toStringAsFixed(1)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  isSelected ? 'Selected on map' : 'Tap to preview',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
