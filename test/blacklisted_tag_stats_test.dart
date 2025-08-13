import 'package:flutter_test/flutter_test.dart';
import 'package:lolisnatcher/src/data/blacklisted_tag_stats.dart';
import 'package:lolisnatcher/src/data/booru_item.dart';

void main() {
  group('BlacklistedTagStats', () {
    late BlacklistedTagStats stats;

    setUp(() {
      stats = BlacklistedTagStats();
    });

    test('should track filtered items and tag counts', () {
      // Create mock items
      final item1 = BooruItem(
        fileURL: 'test1.jpg',
        sampleURL: 'sample1.jpg',
        thumbnailURL: 'thumb1.jpg',
        tagsList: ['tag1', 'tag2', 'safe'],
        postURL: 'post1',
      );

      final item2 = BooruItem(
        fileURL: 'test2.jpg',
        sampleURL: 'sample2.jpg',
        thumbnailURL: 'thumb2.jpg',
        tagsList: ['tag1', 'tag3', 'safe'],
        postURL: 'post2',
      );

      // Add filtered items
      stats.addFilteredItem(item1, ['tag1']);
      stats.addFilteredItem(item2, ['tag1']);

      // Verify counts
      expect(stats.getCountForTag('tag1'), 2);
      expect(stats.getCountForTag('tag2'), 0);
      expect(stats.hasStats, true);

      // Verify filtered items
      final filteredItems = stats.getFilteredItemsForTag('tag1');
      expect(filteredItems.length, 2);
      expect(filteredItems.contains(item1), true);
      expect(filteredItems.contains(item2), true);
    });

    test('should handle temporarily disabled tags', () {
      final item = BooruItem(
        fileURL: 'test.jpg',
        sampleURL: 'sample.jpg',
        thumbnailURL: 'thumb.jpg',
        tagsList: ['tag1'],
        postURL: 'post',
      );

      stats.addFilteredItem(item, ['tag1']);
      
      // Initially not disabled
      expect(stats.isTagTemporarilyDisabled('tag1'), false);
      
      // Disable tag
      stats.temporarilyDisableTag('tag1');
      expect(stats.isTagTemporarilyDisabled('tag1'), true);
      
      // Check items to re-add
      final itemsToReAdd = stats.getItemsToReAdd();
      expect(itemsToReAdd.length, 1);
      expect(itemsToReAdd.contains(item), true);
      
      // Re-enable tag
      stats.reEnableTag('tag1');
      expect(stats.isTagTemporarilyDisabled('tag1'), false);
      expect(stats.getItemsToReAdd().length, 0);
    });

    test('should clear statistics', () {
      final item = BooruItem(
        fileURL: 'test.jpg',
        sampleURL: 'sample.jpg',
        thumbnailURL: 'thumb.jpg',
        tagsList: ['tag1'],
        postURL: 'post',
      );

      stats.addFilteredItem(item, ['tag1']);
      stats.temporarilyDisableTag('tag1');
      
      expect(stats.hasStats, true);
      
      stats.clear();
      
      expect(stats.hasStats, false);
      expect(stats.getCountForTag('tag1'), 0);
      expect(stats.isTagTemporarilyDisabled('tag1'), false);
    });

    test('should sort entries by count descending', () {
      final item1 = BooruItem(
        fileURL: 'test1.jpg',
        sampleURL: 'sample1.jpg',
        thumbnailURL: 'thumb1.jpg',
        tagsList: ['tag1'],
        postURL: 'post1',
      );

      final item2 = BooruItem(
        fileURL: 'test2.jpg',
        sampleURL: 'sample2.jpg',
        thumbnailURL: 'thumb2.jpg',
        tagsList: ['tag2'],
        postURL: 'post2',
      );

      // Add different counts
      stats.addFilteredItem(item1, ['tag1']);
      stats.addFilteredItem(item2, ['tag2']);
      stats.addFilteredItem(item2, ['tag2']); // tag2 should have count 2

      final sortedEntries = stats.sortedEntries;
      expect(sortedEntries.length, 2);
      expect(sortedEntries[0].key, 'tag2'); // Higher count first
      expect(sortedEntries[0].value, 2);
      expect(sortedEntries[1].key, 'tag1');
      expect(sortedEntries[1].value, 1);
    });
  });
}