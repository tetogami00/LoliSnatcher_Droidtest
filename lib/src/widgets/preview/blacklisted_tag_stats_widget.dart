import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lolisnatcher/src/data/blacklisted_tag_stats.dart';
import 'package:lolisnatcher/src/handlers/search_handler.dart';

class BlacklistedTagStatsWidget extends StatelessWidget {
  const BlacklistedTagStatsWidget({
    required this.stats,
    this.onTagTap,
    super.key,
  });

  final BlacklistedTagStats stats;
  final void Function(String tag)? onTagTap;

  SearchHandler get searchHandler => SearchHandler.instance;

  void defaultOnTagTap(String tag) {
    // Toggle the temporarily disabled state for this tag
    if (stats.isTagTemporarilyDisabled(tag)) {
      stats.reEnableTag(tag);
    } else {
      stats.temporarilyDisableTag(tag);
    }
    
    // Refresh the current results to show/hide items based on the new state
    searchHandler.currentTab.booruHandler.filterFetched();
  }

  void handleTagTap(String tag) {
    if (onTagTap != null) {
      onTagTap!(tag);
    } else {
      defaultOnTagTap(tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!stats.hasStats) {
      return const SizedBox.shrink();
    }

    final sortedEntries = stats.sortedEntries;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.eye_slash,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Hidden by blacklisted tags:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: sortedEntries.map((entry) {
              final String tag = entry.key;
              final int count = entry.value;
              final bool isDisabled = stats.isTagTemporarilyDisabled(tag);
              
              return GestureDetector(
                onTap: () => handleTagTap(tag),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDisabled 
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                        : Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDisabled
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isDisabled) ...[
                        Icon(
                          Icons.visibility,
                          size: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        tag,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDisabled
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w500,
                          decoration: isDisabled ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: isDisabled
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          count.toString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDisabled
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onError,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (sortedEntries.any((entry) => stats.isTagTemporarilyDisabled(entry.key))) ...[
            const SizedBox(height: 8),
            Text(
              'Tap tags to hide/show filtered content',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
