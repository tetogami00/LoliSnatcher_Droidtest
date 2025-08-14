import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lolisnatcher/src/handlers/keyboard_handler.dart';

void main() {
  group('KeyboardHandler Static Methods', () {
    test('should get correct key display names', () {
      expect(KeyboardHandler.getKeyDisplayName('Space'), 'Space');
      expect(KeyboardHandler.getKeyDisplayName('ArrowUp'), '↑');
      expect(KeyboardHandler.getKeyDisplayName('ArrowDown'), '↓');
      expect(KeyboardHandler.getKeyDisplayName('ArrowLeft'), '←');
      expect(KeyboardHandler.getKeyDisplayName('ArrowRight'), '→');
      expect(KeyboardHandler.getKeyDisplayName('KeyA'), 'A');
      expect(KeyboardHandler.getKeyDisplayName('Equal'), '+');
      expect(KeyboardHandler.getKeyDisplayName('Minus'), '-');
    });
  });

  group('KeyboardAction', () {
    test('should have correct display names', () {
      expect(KeyboardAction.nextPost.displayName, 'Next Post');
      expect(KeyboardAction.previousPost.displayName, 'Previous Post');
      expect(KeyboardAction.playPause.displayName, 'Play/Pause');
      expect(KeyboardAction.showTags.displayName, 'Show Tags');
    });

    test('should have descriptions', () {
      expect(KeyboardAction.nextPost.description, 'Navigate to the next post');
      expect(KeyboardAction.previousPost.description, 'Navigate to the previous post');
      expect(KeyboardAction.playPause.description, 'Play or pause video playback');
      expect(KeyboardAction.showTags.description, 'Display post tags');
    });
  });
}