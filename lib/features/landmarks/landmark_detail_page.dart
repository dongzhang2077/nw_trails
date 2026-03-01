import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/app/state/app_state.dart';
import 'package:nw_trails/core/models/landmark_category.dart';

class LandmarkDetailPage extends StatefulWidget {
  const LandmarkDetailPage({
    required this.landmarkId,
    super.key,
  });

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

    final CheckInAttemptResult result =
        await appState.attemptCheckIn(widget.landmarkId);

    if (!mounted) {
      return;
    }

    setState(() {
      _isCheckingIn = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.message)),
    );

    if (result.status == CheckInStatus.success) {
      appState.setSelectedTabIndex(2);
    }
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

    return Scaffold(
      appBar: AppBar(
        title: Text(landmark.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Text('Image carousel placeholder'),
          ),
          const SizedBox(height: 12),
          Text(
            landmark.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            '${landmark.category.label} | ${landmark.address}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            landmark.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _isCheckingIn ? null : _handleCheckIn,
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
          const SizedBox(height: 8),
          Text(
            'New check-ins are created only from this page.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
