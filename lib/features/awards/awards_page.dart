import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/core/models/badge_progress.dart';
import 'package:nw_trails/core/models/landmark_category.dart';

class AwardsPage extends StatelessWidget {
  const AwardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final BadgeProgress progress = appState.badgeProgress;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'My Explorer Profile',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${progress.visitedCount}/${progress.totalLandmarks} '
                    'landmarks explored',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: progress.completion),
                  const SizedBox(height: 6),
                  Text(progress.nextBadgeHint),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tier Badges',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _BadgeTile(
            label: 'Bronze (5)',
            earned: progress.bronzeEarned,
            progressText: '${progress.visitedCount}/${progress.bronzeTarget}',
          ),
          const SizedBox(height: 8),
          _BadgeTile(
            label: 'Silver (10)',
            earned: progress.silverEarned,
            progressText: '${progress.visitedCount}/${progress.silverTarget}',
          ),
          const SizedBox(height: 8),
          _BadgeTile(
            label: 'Gold (15)',
            earned: progress.goldEarned,
            progressText: '${progress.visitedCount}/${progress.goldTarget}',
          ),
          const SizedBox(height: 12),
          Text(
            'Theme Badges',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final LandmarkCategory category in LandmarkCategory.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _CategoryProgressTile(category: category),
            ),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({
    required this.label,
    required this.earned,
    required this.progressText,
  });

  final String label;
  final bool earned;
  final String progressText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          earned ? Icons.verified : Icons.lock_outline,
        ),
        title: Text(label),
        subtitle: Text(earned ? 'Earned' : progressText),
      ),
    );
  }
}

class _CategoryProgressTile extends StatelessWidget {
  const _CategoryProgressTile({required this.category});

  final LandmarkCategory category;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final int visited = appState.visitedCountForCategory(category);
    final int total = appState.totalCountForCategory(category);

    return Card(
      child: ListTile(
        title: Text(category.label),
        subtitle: Text('$visited/$total visited'),
      ),
    );
  }
}
