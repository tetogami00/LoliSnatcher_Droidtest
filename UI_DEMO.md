# Blacklisted Tag Statistics UI Demo

## Visual Representation

Below is a textual representation of how the blacklisted tag statistics feature appears in the app:

### When results are loaded with hidden content:

```
┌─────────────────────────────────────────┐
│                                         │
│  🔴 Hidden by blacklisted tags:         │
│                                         │
│  [🚫 nsfw 12] [🚫 explicit 8] [🚫 gore 3] │
│                                         │
└─────────────────────────────────────────┘
```

### After clicking "explicit" to temporarily disable it:

```
┌─────────────────────────────────────────┐
│                                         │
│  🔴 Hidden by blacklisted tags:         │
│                                         │
│  [🚫 nsfw 12] [👁️ explicit 8] [🚫 gore 3] │
│                                         │
│  💡 Tap tags to hide/show filtered content │
│                                         │
└─────────────────────────────────────────┘
```

### Key Visual Elements:

1. **Container**: Semi-transparent rounded container with subtle border
2. **Header**: Small icon + "Hidden by blacklisted tags:" text
3. **Tag Chips**: 
   - **Active (filtering enabled)**: Red background, eye-slash icon, white count badge
   - **Disabled (filtering disabled)**: Blue background, eye icon, strikethrough text, white count badge
4. **Help Text**: Shows when any tags are disabled, explaining the interaction
5. **Sorting**: Tags are sorted by count (highest first)

### Interaction Flow:

1. **User searches** → Some results hidden by blacklisted tags
2. **Stats appear** → Shows which tags hid content and counts
3. **User clicks tag** → Tag becomes disabled, hidden content appears
4. **User clicks again** → Tag re-enabled, content hidden again
5. **New search** → Stats reset for new results

### Example Scenario:

- User searches for "anime art"
- 50 results found, but 25 items were hidden
- Stats show: "nsfw 15", "explicit 8", "violence 2"
- User clicks "nsfw 15" to see those 15 items
- User can click again to hide them
- Each tag operates independently

### Technical Details:

- Appears in the bottom waterfall error/status area
- Only shows when there are actual statistics to display
- Seamlessly integrates with existing loading/error states
- Updates in real-time when tags are toggled
- Automatically clears when starting new searches

This feature provides users with transparency about what content is being filtered and gives them control over viewing that content without permanently changing their blacklist settings.