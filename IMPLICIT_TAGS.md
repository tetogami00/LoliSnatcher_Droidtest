# Implicit Tags Feature

This document describes the implementation of the implicit tags feature in LoliSnatcher.

## Overview

The implicit tags feature allows users to configure tags that are automatically included in every search for a specific booru profile, without displaying these tags in the search bar.

## Use Cases

- **Consistent Ordering**: Always include "order:score" to sort results by score
- **Content Filtering**: Always include "rating:safe" to filter content
- **Quality Control**: Always include "width:>=1920" for high-resolution images
- **Combined Filters**: Include multiple tags like "order:score rating:safe -animated"

## Implementation Details

### Data Model Changes

- Added `implicitTags` field to the `Booru` class
- Updated serialization/deserialization to include implicit tags
- Maintained backward compatibility for existing configurations

### UI Changes

- Added "Implicit tags" input field in the booru edit page
- Field appears after "Default tags" with helpful hint text
- Clear description: "Always included in searches (not shown in search bar)"

### Search Logic

- Modified `SearchHandler.runSearch()` to combine visible tags with implicit tags
- Tags are combined just before sending to the booru handler
- Supports both space-separated (regular boorus) and comma-separated (Hydrus) tags
- Applied to both regular searches and retry searches

### Helper Function

```dart
String _combineTagsWithImplicit(String visibleTags, String? implicitTags) {
  // Combines visible search tags with booru's implicit tags
  // Handles empty cases and different tag separators
}
```

## User Experience

1. **Configuration**: Users can set implicit tags in the booru edit page
2. **Search Behavior**: When searching for "cat girl", if implicit tags are "order:score", the actual search becomes "cat girl order:score"
3. **Search Bar**: Only shows "cat girl" - implicit tags remain hidden
4. **Consistency**: Every search on that booru profile automatically includes the implicit tags

## Example Usage

**Booru Configuration:**
- Name: "Safebooru High Quality"
- Implicit Tags: "order:score rating:safe width:>=1920"

**User Search:** "cat girl"
**Actual API Call:** "cat girl order:score rating:safe width:>=1920"
**Search Bar Shows:** "cat girl"

## Backward Compatibility

- Existing booru configurations without implicit tags continue to work unchanged
- Empty implicit tags field has no effect on searches
- All existing search functionality remains intact

## Testing

- Unit tests for Booru data model serialization
- Integration tests for tag combination logic
- Tests for different booru types (regular vs Hydrus)
- Backward compatibility tests