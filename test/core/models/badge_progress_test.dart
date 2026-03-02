import 'package:flutter_test/flutter_test.dart';
import 'package:nw_trails/core/models/badge_progress.dart';

void main() {
  group('BadgeProgress', () {
    test('returns zero completion when total landmarks is zero', () {
      const progress = BadgeProgress(visitedCount: 3, totalLandmarks: 0);

      expect(progress.completion, 0);
    });

    test('reports tier status and next badge hint by threshold', () {
      const beforeBronze = BadgeProgress(visitedCount: 4, totalLandmarks: 15);
      const bronzeReached = BadgeProgress(visitedCount: 5, totalLandmarks: 15);
      const silverReached = BadgeProgress(visitedCount: 10, totalLandmarks: 15);
      const goldReached = BadgeProgress(visitedCount: 15, totalLandmarks: 15);

      expect(beforeBronze.bronzeEarned, isFalse);
      expect(beforeBronze.nextBadgeHint, 'Next badge: Bronze (5)');

      expect(bronzeReached.bronzeEarned, isTrue);
      expect(bronzeReached.silverEarned, isFalse);
      expect(bronzeReached.nextBadgeHint, 'Next badge: Silver (10)');

      expect(silverReached.silverEarned, isTrue);
      expect(silverReached.goldEarned, isFalse);
      expect(silverReached.nextBadgeHint, 'Next badge: Gold (15)');

      expect(goldReached.goldEarned, isTrue);
      expect(goldReached.nextBadgeHint, 'All tier badges earned.');
    });
  });
}
