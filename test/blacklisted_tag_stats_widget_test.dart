import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lolisnatcher/src/data/blacklisted_tag_stats.dart';
import 'package:lolisnatcher/src/data/booru_item.dart';
import 'package:lolisnatcher/src/widgets/preview/blacklisted_tag_stats_widget.dart';

void main() {
  testWidgets('BlacklistedTagStatsWidget displays correctly', (WidgetTester tester) async {
    // Create test data
    final stats = BlacklistedTagStats();
    final item1 = BooruItem(
      fileURL: 'test1.jpg',
      sampleURL: 'sample1.jpg',
      thumbnailURL: 'thumb1.jpg',
      tagsList: const ['explicit', 'sexual', 'nsfw'],
      postURL: 'post1',
    );
    
    final item2 = BooruItem(
      fileURL: 'test2.jpg',
      sampleURL: 'sample2.jpg',
      thumbnailURL: 'thumb2.jpg',
      tagsList: const ['explicit', 'violence', 'gore'],
      postURL: 'post2',
    );

    // Add some filtered items
    stats.addFilteredItem(item1, const ['explicit']);
    stats.addFilteredItem(item2, const ['explicit', 'violence']);
    stats.addFilteredItem(item1, const ['explicit']); // Same item filtered again

    // Track tapped tags for testing
    String? tappedTag;

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlacklistedTagStatsWidget(
            stats: stats,
            onTagTap: (tag) {
              tappedTag = tag;
              // Simulate the toggle logic for testing
              if (stats.isTagTemporarilyDisabled(tag)) {
                stats.reEnableTag(tag);
              } else {
                stats.temporarilyDisableTag(tag);
              }
            },
          ),
        ),
      ),
    );

    // Verify the widget shows expected content
    expect(find.text('Hidden by blacklisted tags:'), findsOneWidget);
    expect(find.text('explicit'), findsOneWidget);
    expect(find.text('violence'), findsOneWidget);
    expect(find.text('3'), findsOneWidget); // explicit count
    expect(find.text('1'), findsOneWidget); // violence count

    // Test tap functionality
    await tester.tap(find.text('explicit'));
    await tester.pumpAndSettle();

    // Verify the tap was handled
    expect(tappedTag, 'explicit');
    expect(stats.isTagTemporarilyDisabled('explicit'), true);
    expect(stats.isTagTemporarilyDisabled('violence'), false);
  });

  testWidgets('BlacklistedTagStatsWidget shows empty when no stats', (WidgetTester tester) async {
    final stats = BlacklistedTagStats();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlacklistedTagStatsWidget(stats: stats),
        ),
      ),
    );

    // Should show nothing when no stats
    expect(find.byType(Container), findsNothing);
  });
}