# Blacklisted Tag Statistics Feature

This feature adds the ability to display statistics about which blacklisted tags have been hidden in search results, and allows users to temporarily re-enable those tags to view previously hidden content.

## Implementation Overview

### Core Components

1. **BlacklistedTagStats** (`lib/src/data/blacklisted_tag_stats.dart`)
   - Tracks which tags caused items to be filtered
   - Maintains counts for each blacklisted tag
   - Handles temporarily disabling specific tags

2. **BlacklistedTagStatsWidget** (`lib/src/widgets/preview/blacklisted_tag_stats_widget.dart`)
   - UI component that displays tag statistics
   - Shows clickable tags with counts (e.g., "explicit 5")
   - Visual indicators for disabled tags

3. **BooruHandler Modifications** (`lib/src/handlers/booru_handler.dart`)
   - Enhanced `filterFetched()` method to collect statistics
   - Tracks all hated tags while respecting temporarily disabled ones
   - Clears statistics when starting new searches

4. **WaterfallErrorButtons Integration** (`lib/src/widgets/preview/waterfall_error_buttons.dart`)
   - Shows blacklisted tag stats when results are loaded successfully
   - Integrates seamlessly with existing error/status display

### How It Works

1. **During Filtering**: When the `filterFetched()` method processes items, it:
   - Identifies all hated tags in each item
   - Records statistics for all hated tags
   - Only filters items if they have hated tags that are NOT temporarily disabled

2. **Statistics Display**: The stats widget shows:
   - Tag names with counts (sorted by count, highest first)
   - Visual distinction between active and disabled tags
   - Click functionality to toggle tag states

3. **Tag Re-enabling**: When a user clicks a tag:
   - The tag is marked as temporarily disabled
   - The filtering process is re-run
   - Previously hidden items with only that tag become visible

### User Experience

- **Discovery**: Users can see which tags are hiding content and how much
- **Flexibility**: One-click to temporarily disable specific blacklisted tags
- **Visual Feedback**: Clear indication of which tags are currently disabled
- **Automatic Reset**: Statistics clear when starting a new search

### Testing

Comprehensive tests cover:
- Statistics tracking and counting
- Tag disabling/re-enabling functionality
- Widget display and interaction
- Edge cases and data integrity

### Example Usage

If a search returns results but some items are hidden due to blacklisted tags like "nsfw" and "explicit", the user would see:

```
Hidden by blacklisted tags:
[nsfw 12] [explicit 8] [violence 3]
```

Clicking on "nsfw 12" would temporarily disable that filter, showing the 12 previously hidden items, with "nsfw" visually indicated as disabled.

## Code Quality

- Follows existing code patterns and conventions
- Minimal changes to core functionality
- Comprehensive test coverage
- Type-safe implementation
- Proper error handling