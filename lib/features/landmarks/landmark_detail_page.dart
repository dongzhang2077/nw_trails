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
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (isSuccess) ...<Widget>[
                Icon(
                  Icons.celebration,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(height: 10),
              ],
              Text(body),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(_PostCheckInAction.stayHere);
              },
              child: Text(isSuccess ? 'Done' : 'Stay'),
            ),
            if (!isSuccess)
              TextButton(
                onPressed: () {
                  Navigator.of(
                    dialogContext,
                  ).pop(_PostCheckInAction.viewHistory);
                },
                child: const Text('View history'),
              ),
            if (isSuccess)
              TextButton(
                onPressed: () {
                  Navigator.of(
                    dialogContext,
                  ).pop(_PostCheckInAction.viewHistory);
                },
                child: const Text('View history'),
              ),
            if (isSuccess)
              FilledButton(
                onPressed: () {
                  Navigator.of(
                    dialogContext,
                  ).pop(_PostCheckInAction.viewAwards);
                },
                child: const Text('View awards'),
              ),
            if (canGoToNextStop)
              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(
                    dialogContext,
                  ).pop(_PostCheckInAction.goToNextStop);
                },
                child: Text('Go to next stop: $nextRouteStopName'),
              ),
          ],
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
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Theme.of(context).colorScheme.primary.withOpacity(0.18),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.14),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
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
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(landmark.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              Chip(
                label: Text(landmark.category.label),
                backgroundColor: categoryChipColor.withOpacity(0.16),
                side: BorderSide.none,
                labelStyle: TextStyle(
                  color: categoryChipColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Chip(
                avatar: const Icon(Icons.place_outlined, size: 16),
                label: Text(landmark.address),
                side: BorderSide.none,
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
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
          Text('About', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            landmark.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          Text(
            'Practical tips: best visited during daylight. Bring comfortable shoes for walking routes nearby.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Text(
            'Tips from students',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '"Great stop for photos and easy check-in once you are close to the entrance." - NW Student',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
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
            FilledButton(
              onPressed: _isCheckingIn ? null : _handleCheckIn,
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(_isCheckingIn ? 'Checking in...' : 'CHECK IN'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Directions integration pending.'),
                  ),
                );
              },
              child: const Text('GET DIRECTIONS'),
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

enum _PostCheckInAction { stayHere, viewHistory, viewAwards, goToNextStop }
