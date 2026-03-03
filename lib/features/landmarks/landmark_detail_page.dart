import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/app/state/app_state.dart';
import 'package:nw_trails/core/constants/category_colors.dart';
import 'package:nw_trails/core/models/landmark_category.dart';

class LandmarkDetailPage extends StatefulWidget {
  const LandmarkDetailPage({required this.landmarkId, super.key});

  final String landmarkId;

  @override
  State<LandmarkDetailPage> createState() => _LandmarkDetailPageState();
}

class _LandmarkDetailPageState extends State<LandmarkDetailPage> {
  bool _isCheckingIn = false;

  Future<void> _handleCheckIn() async {
    if (_isCheckingIn) {
      return;
    }

    final AppState appState = AppScope.of(context);

    setState(() {
      _isCheckingIn = true;
    });

    final CheckInAttemptResult result = await appState.attemptCheckIn(
      widget.landmarkId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isCheckingIn = false;
    });

    String? nextRouteStopName;
    if (result.status == CheckInStatus.success) {
      final String? activeRouteId = appState.activeRouteId;
      if (activeRouteId != null) {
        final String? nextStopId = appState.nextUnvisitedLandmarkIdForRoute(
          activeRouteId,
        );
        if (nextStopId != null) {
          nextRouteStopName = appState.landmarkNameById(nextStopId);
        }
      }
    }

    final _PostCheckInAction? action = await _showCheckInResultDialog(
      context: context,
      result: result,
      landmarkName: appState.landmarkNameById(widget.landmarkId),
      checkedAt: DateTime.now(),
      visitedCount: appState.badgeProgress.visitedCount,
      totalLandmarks: appState.badgeProgress.totalLandmarks,
      nextBadgeHint: appState.badgeProgress.nextBadgeHint,
      nextRouteStopName: nextRouteStopName,
    );

    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case _PostCheckInAction.stayHere:
        break;
      case _PostCheckInAction.viewHistory:
        appState.setSelectedTabIndex(1);
        Navigator.of(context).pop();
        return;
      case _PostCheckInAction.viewAwards:
        appState.setSelectedTabIndex(2);
        Navigator.of(context).pop();
        return;
      case _PostCheckInAction.goToNextStop:
        appState.setSelectedTabIndex(0);
        Navigator.of(context).pop();
        return;
    }
  }

  Future<_PostCheckInAction?> _showCheckInResultDialog({
    required BuildContext context,
    required CheckInAttemptResult result,
    required String landmarkName,
    required DateTime checkedAt,
    required int visitedCount,
    required int totalLandmarks,
    required String nextBadgeHint,
    required String? nextRouteStopName,
  }) {
    final bool isSuccess = result.status == CheckInStatus.success;
    final bool canGoToNextStop = isSuccess && nextRouteStopName != null;
    final double progressFraction = totalLandmarks == 0
        ? 0
        : (visitedCount / totalLandmarks).clamp(0.0, 1.0);

    final String title = switch (result.status) {
      CheckInStatus.success => 'Checked in!',
      CheckInStatus.permissionDenied => 'Location permission required',
      CheckInStatus.outOfRange => 'Too far away',
      CheckInStatus.duplicate => 'Already checked in today',
    };

    final String body = switch (result.status) {
      CheckInStatus.success =>
        'Landmark: $landmarkName\nTime: ${_formatDate(checkedAt)}\n\n${result.message}\n\nProgress: $visitedCount/$totalLandmarks\n$nextBadgeHint',
      CheckInStatus.permissionDenied =>
        '${result.message}\n\nEnable location permission to verify your visit.',
      CheckInStatus.outOfRange =>
        result.distanceMeters == null
            ? result.message
            : '${result.message}\n\nDistance: ${result.distanceMeters} m (must be within 50 m).',
      CheckInStatus.duplicate =>
        '${result.message}\n\nYou can review your check-in history anytime from the Check-in tab.',
    };

    return showDialog<_PostCheckInAction>(
      context: context,
      barrierColor: const Color(0x470D1218),
      builder: (BuildContext dialogContext) {
        final ThemeData theme = Theme.of(dialogContext);
        final ColorScheme colors = theme.colorScheme;

        Widget quickAction({
          required String label,
          required _PostCheckInAction action,
        }) {
          return OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 34),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              side: BorderSide(color: colors.outlineVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              foregroundColor: colors.onSurface,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(action);
            },
            child: Text(label),
          );
        }

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 330),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (isSuccess) ...<Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8F2E3),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.check,
                            size: 17,
                            color: Color(0xFF177245),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Check-in Successful',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$landmarkName - ${_formatDate(checkedAt)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      result.message,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Progress',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        Text(
                          '$visitedCount/$totalLandmarks landmarks',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: SizedBox(
                        height: 10,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            const ColoredBox(color: Color(0xFFE8EDF2)),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: progressFraction,
                                child: const ColoredBox(color: Color(0xFFFF6B35)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Next badge: $nextBadgeHint',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        quickAction(
                          label: 'View history',
                          action: _PostCheckInAction.viewHistory,
                        ),
                        quickAction(
                          label: 'View awards',
                          action: _PostCheckInAction.viewAwards,
                        ),
                        if (canGoToNextStop)
                          quickAction(
                            label: 'Next stop',
                            action: _PostCheckInAction.goToNextStop,
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop(_PostCheckInAction.stayHere);
                        },
                        child: const Text('Done'),
                      ),
                    ),
                  ] else ...<Widget>[
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(body, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(_PostCheckInAction.stayHere);
                          },
                          child: const Text('Stay'),
                        ),
                        const SizedBox(width: 6),
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(_PostCheckInAction.viewHistory);
                          },
                          child: const Text('View history'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final landmark = appState.findLandmarkById(widget.landmarkId);

    if (landmark == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Landmark')),
        body: const Center(child: Text('Landmark not found.')),
      );
    }

    final int totalCheckIns = appState.checkInRecords
        .where((record) => record.landmarkId == landmark.id)
        .length;
    final Color categoryChipColor = categoryColor(landmark.category);
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(landmark.name),
        actions: <Widget>[
          IconButton(
            tooltip: 'Save',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved to favorites (stub).')),
              );
            },
            icon: const Icon(Icons.bookmark_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Container(
            height: 216,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
                  Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.14),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(
                  landmark.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      alignment: Alignment.center,
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 34,
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Text(
                      landmark.address,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(landmark.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: categoryChipColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Text(
                  landmark.category.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: categoryChipColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.place_outlined,
                        size: 14,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          landmark.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _InfoMetric(
                      icon: Icons.social_distance,
                      label: 'Distance',
                      value: '<= 50m for check-in',
                    ),
                  ),
                  Expanded(
                    child: _InfoMetric(
                      icon: Icons.verified,
                      label: 'Total check-ins',
                      value: '$totalCheckIns',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _InfoSectionCard(
            title: 'About',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  landmark.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  'Practical tips: best visited during daylight. Bring comfortable shoes for walking routes nearby.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _InfoSectionCard(
            title: 'Tips from students',
            child: Text(
              '"Great stop for photos and easy check-in once you are close to the entrance." - NW Student',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'New check-ins are created only from this page.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FilledButton.icon(
              onPressed: _isCheckingIn ? null : _handleCheckIn,
              icon: Icon(
                _isCheckingIn ? Icons.hourglass_top : Icons.check_circle,
              ),
              label: Text(_isCheckingIn ? 'Checking in...' : 'CHECK IN'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Directions integration pending.'),
                  ),
                );
              },
              icon: const Icon(Icons.near_me_outlined),
              label: const Text('GET DIRECTIONS'),
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
}

class _InfoMetric extends StatelessWidget {
  const _InfoMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoSectionCard extends StatelessWidget {
  const _InfoSectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

enum _PostCheckInAction { stayHere, viewHistory, viewAwards, goToNextStop }
