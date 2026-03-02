import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/core/constants/category_colors.dart';
import 'package:nw_trails/core/models/badge_progress.dart';
import 'package:nw_trails/core/models/checkin_record.dart';
import 'package:nw_trails/core/models/landmark_category.dart';
import 'package:nw_trails/features/landmarks/landmark_detail_page.dart';

class AwardsPage extends StatelessWidget {
  const AwardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final BadgeProgress progress = appState.badgeProgress;
    final List<CheckInRecord> recentRecords = appState.checkInRecords
        .take(3)
        .toList(growable: false);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Center(
            child: Text(
              'My Explorer Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 10),
          _ProfileHeaderCard(progress: progress),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Badges - Tier',
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _TierBadgeCard(
                    label: 'Bronze (5)',
                    earned: progress.bronzeEarned,
                    progressText: progress.bronzeEarned
                        ? 'Earned'
                        : '${progress.visitedCount}/${progress.bronzeTarget}',
                    highlightColor: const Color(0xFF8B6914),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TierBadgeCard(
                    label: 'Silver (10)',
                    earned: progress.silverEarned,
                    progressText: '${progress.visitedCount}/${progress.silverTarget}',
                    highlightColor: const Color(0xFF8A97A8),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TierBadgeCard(
                    label: 'Gold (15)',
                    earned: progress.goldEarned,
                    progressText: '${progress.visitedCount}/${progress.goldTarget}',
                    highlightColor: const Color(0xFFE0A91E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Badges - Theme',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final LandmarkCategory category in LandmarkCategory.values)
                  SizedBox(
                    width: 102,
                    child: _ThemeBadgeCard(category: category),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Check-in History (Most Recent)',
            child: recentRecords.isEmpty
                ? Text(
                    'No check-ins yet. Check in from a landmark detail page.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                : Column(
                    children: <Widget>[
                      for (int index = 0; index < recentRecords.length; index++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: index == recentRecords.length - 1 ? 0 : 8,
                          ),
                          child: _RecentCheckInTile(
                            record: recentRecords[index],
                            index: index,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.progress});

  final BadgeProgress progress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: <Widget>[
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
              ),
              alignment: Alignment.center,
              child: Text(
                'DZ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('dong.zhang', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '${progress.visitedCount}/${progress.totalLandmarks} landmarks explored',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: const SizedBox(
                height: 10,
                child: ColoredBox(color: Color(0xFFE2E8ED)),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 10,
                  child: FractionallySizedBox(
                    widthFactor: progress.completion.clamp(0.0, 1.0),
                    alignment: Alignment.centerLeft,
                    child: const ColoredBox(color: Color(0xFFFF7B2C)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

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
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _TierBadgeCard extends StatelessWidget {
  const _TierBadgeCard({
    required this.label,
    required this.earned,
    required this.progressText,
    required this.highlightColor,
  });

  final String label;
  final bool earned;
  final String progressText;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: earned ? highlightColor.withOpacity(0.12) : Colors.transparent,
        border: Border.all(
          color: earned ? highlightColor.withOpacity(0.45) : const Color(0xFFE1E5E9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Text(
            progressText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: earned ? const Color(0xFF2E7D32) : null,
              fontWeight: earned ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeBadgeCard extends StatelessWidget {
  const _ThemeBadgeCard({required this.category});

  final LandmarkCategory category;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final int visited = appState.visitedCountForCategory(category);
    final int total = appState.totalCountForCategory(category);
    final Color tagColor = categoryColor(category);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E5E9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_themeBadgeName(category), style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 18),
          Text(
            '$visited/$total',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: tagColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _themeBadgeName(LandmarkCategory category) {
    return switch (category) {
      LandmarkCategory.historic => 'History Buff',
      LandmarkCategory.nature => 'Nature Lover',
      LandmarkCategory.food => 'Foodie Explorer',
      LandmarkCategory.culture => 'Culture Seeker',
    };
  }
}

class _RecentCheckInTile extends StatelessWidget {
  const _RecentCheckInTile({required this.record, required this.index});

  final CheckInRecord record;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final landmark = appState.findLandmarkById(record.landmarkId);
    final bool hasPhoto = index.isEven;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => LandmarkDetailPage(landmarkId: record.landmarkId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E5E9)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFD8EFF2),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    appState.landmarkNameById(record.landmarkId),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    _dateOnly(record.checkedInAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFE1E5E9)),
              ),
              child: Text(hasPhoto ? 'Photo' : 'No Photo'),
            ),
            if (landmark != null) ...<Widget>[
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _dateOnly(DateTime dateTime) {
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }
}
