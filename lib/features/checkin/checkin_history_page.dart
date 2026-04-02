import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/core/constants/category_colors.dart';
import 'package:nw_trails/core/models/checkin_record.dart';
import 'package:nw_trails/core/models/landmark_category.dart';
import 'package:nw_trails/features/landmarks/landmark_detail_page.dart';

class CheckInHistoryPage extends StatefulWidget {
  const CheckInHistoryPage({super.key});

  @override
  State<CheckInHistoryPage> createState() => _CheckInHistoryPageState();
}

enum _HistoryFilter { all, last7Days, today }

class _CheckInHistoryPageState extends State<CheckInHistoryPage> {
  _HistoryFilter _filter = _HistoryFilter.all;
  final Map<String, Uint8List?> _photoBytesCache = <String, Uint8List?>{};
  final Set<String> _loadingPhotoUrls = <String>{};

  Future<Uint8List?> _loadPhotoBytes(String photoUrl) async {
    final appState = AppScope.of(context);

    Uint8List? bytes = _photoBytesCache[photoUrl];
    if (bytes == null && !_loadingPhotoUrls.contains(photoUrl)) {
      setState(() {
        _loadingPhotoUrls.add(photoUrl);
      });
      bytes = await appState.loadCheckInPhotoBytes(photoUrl);
      if (mounted) {
        setState(() {
          _loadingPhotoUrls.remove(photoUrl);
          _photoBytesCache[photoUrl] = bytes;
        });
      }
    }

    return bytes;
  }

  bool _isAnyPhotoLoading(List<String> photoUrls) {
    for (final String photoUrl in photoUrls) {
      if (_loadingPhotoUrls.contains(photoUrl)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _showPhotoPreview(Uint8List bytes) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: InteractiveViewer(
                    child: Image.memory(bytes, fit: BoxFit.contain),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCheckInPhotos(List<String> photoUrls) async {
    final List<MapEntry<String, Uint8List>> loadedPhotos =
        <MapEntry<String, Uint8List>>[];

    for (final String photoUrl in photoUrls) {
      final Uint8List? bytes = await _loadPhotoBytes(photoUrl);
      if (bytes != null) {
        loadedPhotos.add(MapEntry<String, Uint8List>(photoUrl, bytes));
      }
    }

    if (!mounted) {
      return;
    }

    if (loadedPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo preview is unavailable.')),
      );
      return;
    }

    if (loadedPhotos.length == 1) {
      await _showPhotoPreview(loadedPhotos.first.value);
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${loadedPhotos.length} photos',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 320,
                  height: 300,
                  child: GridView.builder(
                    itemCount: loadedPhotos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      final Uint8List bytes = loadedPhotos[index].value;
                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => _showPhotoPreview(bytes),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(bytes, fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final List<CheckInRecord> allRecords = appState.checkInRecords;
    final DateTime now = DateTime.now();

    final List<CheckInRecord> records = allRecords
        .where((record) {
          return switch (_filter) {
            _HistoryFilter.all => true,
            _HistoryFilter.last7Days =>
              now.difference(record.checkedInAt).inDays < 7,
            _HistoryFilter.today => _isSameDay(record.checkedInAt, now),
          };
        })
        .toList(growable: false);

    final Set<String> uniqueLandmarkIds = allRecords
        .map((record) => record.landmarkId)
        .toSet();
    final int uniqueCategoriesVisited = allRecords
        .map((record) => appState.findLandmarkById(record.landmarkId)?.category)
        .whereType<LandmarkCategory>()
        .toSet()
        .length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Check-in History',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Review your latest check-ins. Tap an item to open landmark details.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.history,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 98,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _StatCard(
                      label: 'Check-ins',
                      value: '${allRecords.length}',
                      icon: Icons.fact_check,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      label: 'Landmarks',
                      value: '${uniqueLandmarkIds.length}',
                      icon: Icons.place,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      label: 'Categories',
                      value: '$uniqueCategoriesVisited/4',
                      icon: Icons.grid_view,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _FilterChip(
                    label: 'All',
                    selected: _filter == _HistoryFilter.all,
                    onTap: () {
                      setState(() {
                        _filter = _HistoryFilter.all;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Last 7 days',
                    selected: _filter == _HistoryFilter.last7Days,
                    onTap: () {
                      setState(() {
                        _filter = _HistoryFilter.last7Days;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Today',
                    selected: _filter == _HistoryFilter.today,
                    onTap: () {
                      setState(() {
                        _filter = _HistoryFilter.today;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: records.isEmpty
                  ? _EmptyState(filter: _filter)
                  : ListView.separated(
                      itemCount: records.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final CheckInRecord item = records[index];
                        final List<String> photoUrls = item.photoUrls;
                        final landmark = appState.findLandmarkById(
                          item.landmarkId,
                        );
                        final categoryLabel =
                            landmark?.category.label ?? 'Unknown';
                        final categoryTagColor = landmark == null
                            ? Theme.of(context).colorScheme.outline
                            : categoryColor(landmark.category);
                        final bool isFirst = index == 0;
                        final bool isLast = index == records.length - 1;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _TimelineMarker(
                              isFirst: isFirst,
                              isLast: isLast,
                              color: categoryTagColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Card(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) {
                                          return LandmarkDetailPage(
                                            landmarkId: item.landmarkId,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: SizedBox(
                                                width: 70,
                                                height: 56,
                                                child: landmark == null
                                                    ? Container(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surfaceContainerHighest,
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Icon(
                                                          Icons
                                                              .image_not_supported_outlined,
                                                          size: 20,
                                                        ),
                                                      )
                                                    : Image.network(
                                                        landmark.imageUrl,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) {
                                                              return Container(
                                                                color: Theme.of(context)
                                                                    .colorScheme
                                                                    .surfaceContainerHighest,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: const Icon(
                                                                  Icons
                                                                      .image_not_supported_outlined,
                                                                  size: 20,
                                                                ),
                                                              );
                                                            },
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    appState.landmarkNameById(
                                                      item.landmarkId,
                                                    ),
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.titleMedium,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    _formatDate(
                                                      item.checkedInAt,
                                                    ),
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Icon(Icons.chevron_right),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: <Widget>[
                                            Chip(
                                              label: Text(categoryLabel),
                                              backgroundColor: categoryTagColor
                                                  .withValues(alpha: 0.12),
                                              side: BorderSide.none,
                                              visualDensity:
                                                  const VisualDensity(
                                                    horizontal: -2,
                                                    vertical: -2,
                                                  ),
                                              labelStyle: TextStyle(
                                                color: categoryTagColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (landmark != null)
                                              Chip(
                                                avatar: const Icon(
                                                  Icons.star,
                                                  size: 16,
                                                ),
                                                label: Text(
                                                  landmark.rating
                                                      .toStringAsFixed(1),
                                                ),
                                                side: BorderSide.none,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surfaceContainerHighest,
                                                visualDensity:
                                                    const VisualDensity(
                                                      horizontal: -2,
                                                      vertical: -2,
                                                    ),
                                              ),
                                            if (photoUrls.isNotEmpty)
                                              Chip(
                                                avatar: const Icon(
                                                  Icons.photo_camera_outlined,
                                                  size: 16,
                                                ),
                                                label: Text(
                                                  'Photos (${photoUrls.length})',
                                                ),
                                                side: BorderSide.none,
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).colorScheme.primaryContainer,
                                                visualDensity:
                                                    const VisualDensity(
                                                      horizontal: -2,
                                                      vertical: -2,
                                                    ),
                                              ),
                                          ],
                                        ),
                                        if (photoUrls.isNotEmpty) ...<Widget>[
                                          const SizedBox(height: 6),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton.icon(
                                              onPressed: _isAnyPhotoLoading(
                                                    photoUrls,
                                                  )
                                                  ? null
                                                  : () => _openCheckInPhotos(
                                                      photoUrls,
                                                    ),
                                              icon: _isAnyPhotoLoading(
                                                    photoUrls,
                                                  )
                                                  ? const SizedBox(
                                                      width: 14,
                                                      height: 14,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                    )
                                                  : const Icon(
                                                      Icons.remove_red_eye,
                                                    ),
                                              label: const Text('View photos'),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String day = dateTime.day.toString().padLeft(2, '0');
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day $hour:$minute';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter});

  final _HistoryFilter filter;

  @override
  Widget build(BuildContext context) {
    final String title = switch (filter) {
      _HistoryFilter.all => 'No check-ins yet',
      _HistoryFilter.last7Days => 'No check-ins in last 7 days',
      _HistoryFilter.today => 'No check-ins today',
    };
    final String body = switch (filter) {
      _HistoryFilter.all =>
        'Complete your first check-in from a landmark detail page.',
      _HistoryFilter.last7Days =>
        'Try exploring a nearby landmark and check in this week.',
      _HistoryFilter.today =>
        'You can check in from any landmark detail while on-site.',
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.history,
            size: 44,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 15, color: colors.primary),
              ),
              const SizedBox(height: 6),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return ChoiceChip(
      label: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: selected ? Colors.white : colors.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: selected,
      showCheckmark: false,
      selectedColor: colors.primary,
      backgroundColor: colors.surface,
      side: BorderSide(
        color: selected ? colors.primary : colors.outlineVariant,
      ),
      visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
      onSelected: (_) => onTap(),
    );
  }
}

class _TimelineMarker extends StatelessWidget {
  const _TimelineMarker({
    required this.isFirst,
    required this.isLast,
    required this.color,
  });

  final bool isFirst;
  final bool isLast;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final Color lineColor = Theme.of(context).colorScheme.outlineVariant;

    return SizedBox(
      width: 20,
      child: Column(
        children: <Widget>[
          Container(
            width: 2,
            height: 20,
            color: isFirst ? Colors.transparent : lineColor,
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          Container(
            width: 2,
            height: 94,
            color: isLast ? Colors.transparent : lineColor,
          ),
        ],
      ),
    );
  }
}
