import 'package:lolisnatcher/src/data/booru_item.dart';

/// Statistics about blacklisted tags that have been filtered out
class BlacklistedTagStats {
  BlacklistedTagStats();

  /// Map of tag name to count of how many times it caused filtering
  final Map<String, int> _tagCounts = {};

  /// Map of tag name to list of items that were filtered due to that tag
  final Map<String, List<BooruItem>> _filteredItems = {};

  /// Set of tags that are temporarily disabled for filtering
  final Set<String> _temporarilyDisabledTags = {};

  /// Get the count for a specific tag
  int getCountForTag(String tag) => _tagCounts[tag] ?? 0;

  /// Get all tag counts as a map
  Map<String, int> get tagCounts => Map.unmodifiable(_tagCounts);

  /// Get filtered items for a specific tag
  List<BooruItem> getFilteredItemsForTag(String tag) => _filteredItems[tag] ?? [];

  /// Check if a tag is temporarily disabled
  bool isTagTemporarilyDisabled(String tag) => _temporarilyDisabledTags.contains(tag);

  /// Add a filtered item with the hated tags that caused it to be filtered
  void addFilteredItem(BooruItem item, List<String> hatedTags) {
    for (final tag in hatedTags) {
      _tagCounts[tag] = (_tagCounts[tag] ?? 0) + 1;
      _filteredItems[tag] ??= [];
      if (!_filteredItems[tag]!.contains(item)) {
        _filteredItems[tag]!.add(item);
      }
    }
  }

  /// Temporarily disable filtering for a specific tag
  void temporarilyDisableTag(String tag) {
    _temporarilyDisabledTags.add(tag);
  }

  /// Re-enable filtering for a specific tag
  void reEnableTag(String tag) {
    _temporarilyDisabledTags.remove(tag);
  }

  /// Clear all statistics (called when starting a new search)
  void clear() {
    _tagCounts.clear();
    _filteredItems.clear();
    _temporarilyDisabledTags.clear();
  }

  /// Get items that should be re-added due to temporarily disabled tags
  List<BooruItem> getItemsToReAdd() {
    final List<BooruItem> itemsToReAdd = [];
    for (final tag in _temporarilyDisabledTags) {
      final items = _filteredItems[tag] ?? [];
      for (final item in items) {
        if (!itemsToReAdd.contains(item)) {
          itemsToReAdd.add(item);
        }
      }
    }
    return itemsToReAdd;
  }

  /// Check if there are any statistics to display
  bool get hasStats => _tagCounts.isNotEmpty;

  /// Get a list of entries sorted by count (descending)
  List<MapEntry<String, int>> get sortedEntries {
    final entries = _tagCounts.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }
}
