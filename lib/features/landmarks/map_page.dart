import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/app/state/app_state.dart';
import 'package:nw_trails/core/constants/category_colors.dart';
import 'package:nw_trails/core/models/landmark.dart';
import 'package:nw_trails/core/models/landmark_category.dart';
import 'package:nw_trails/features/landmarks/landmark_detail_page.dart';
import 'package:nw_trails/features/landmarks/map.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String? _selectedLandmarkId;
  String? _lastAutoFocusKey;
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

  int _mockDistanceMeters(String landmarkId) {
    final int seed = int.tryParse(landmarkId.replaceFirst('l', '')) ?? 1;
    return 70 + (seed * 13);
  }

  int _mockCheckInCount(String landmarkId, int realCheckInCount) {
    final int seed = int.tryParse(landmarkId.replaceFirst('l', '')) ?? 1;
    return 120 + seed * 11 + realCheckInCount;
  }

  void _focusNextRouteStopIfNeeded({
    required AppState appState,
    required String? routeId,
    required String? nextStopId,
  }) {
    if (routeId == null || nextStopId == null) {
      _lastAutoFocusKey = null;
      return;
    }

    final String focusKey = '$routeId:$nextStopId';
    if (_lastAutoFocusKey == focusKey) {
      return;
    }

    final Landmark? nextLandmark = appState.findLandmarkById(nextStopId);
    if (nextLandmark == null) {
      return;
    }

    _lastAutoFocusKey = focusKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      appState.setCategory(null);
      _selectLandmark(nextLandmark, fromExplore: true);
    });
  }

  void _focusRouteLandmark(AppState appState, String landmarkId) {
    final Landmark? landmark = appState.findLandmarkById(landmarkId);
    if (landmark == null) {
      return;
    }
    appState.setCategory(null);
    _selectLandmark(landmark, fromExplore: true);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final activeRoute = appState.activeRoute;
    final int activeRouteCompletedStops = activeRoute == null
        ? 0
        : appState.completedStopCountForRoute(activeRoute);
    final String? nextRouteStopId = activeRoute == null
        ? null
        : appState.nextUnvisitedLandmarkIdForRoute(activeRoute.id);
    final String? nextRouteStopName = nextRouteStopId == null
        ? null
        : appState.landmarkNameById(nextRouteStopId);
    _focusNextRouteStopIfNeeded(
      appState: appState,
      routeId: activeRoute?.id,
      nextStopId: nextRouteStopId,
    );
    final List<Landmark> landmarks = appState.filteredLandmarks;

    Landmark? selectedLandmark;
    for (final Landmark landmark in landmarks) {
      if (landmark.id == _selectedLandmarkId) {
        selectedLandmark = landmark;
        break;
      }
    }
    selectedLandmark ??= landmarks.isEmpty ? null : landmarks.first;

    final List<Landmark> highlightedLandmarks = landmarks
        .where((landmark) {
          return landmark.id != selectedLandmark?.id;
        })
        .take(5)
        .toList(growable: false);

    final Set<String> alreadyShownIds = <String>{
      if (selectedLandmark != null) selectedLandmark.id,
      ...highlightedLandmarks.map((landmark) => landmark.id),
    };
    final List<Landmark> remainingLandmarks = landmarks
        .where((landmark) {
          return !alreadyShownIds.contains(landmark.id);
        })
        .toList(growable: false);

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
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'Profile',
                  onPressed: () {
                    appState.setSelectedTabIndex(2);
                  },
                  icon: Icon(
                    Icons.person,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.route,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Active route: ${activeRoute.name}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            nextRouteStopName == null
                                ? 'Route completed. Nice work!'
                                : 'Next stop: $nextRouteStopName '
                                      '($activeRouteCompletedStops/'
                                      '${activeRoute.landmarkIds.length})',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (nextRouteStopId != null)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () {
                                  _focusRouteLandmark(
                                    appState,
                                    nextRouteStopId,
                                  );
                                },
                                icon: const Icon(Icons.my_location),
                                label: const Text('FOCUS NEXT STOP'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            height: 370,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: NwTrailsMap(
                landmarks: landmarks,
                selectedLandmarkId: selectedLandmark?.id,
                onLandmarkTap: _selectLandmark,
              ),
            ),
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
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported_outlined),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(landmark.name, style: Theme.of(context).textTheme.titleMedium),
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
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
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
