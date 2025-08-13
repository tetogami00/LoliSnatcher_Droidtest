import 'package:flutter/material.dart';

import 'package:lolisnatcher/src/data/keybind_action.dart';
import 'package:lolisnatcher/src/handlers/input_handler.dart';
import 'package:lolisnatcher/src/widgets/common/settings_widgets.dart';
import 'package:lolisnatcher/src/widgets/settings/keybind_config_widget.dart';

/// Settings page for configuring keyboard shortcuts and controller keybinds
class KeybindSettingsPage extends StatefulWidget {
  const KeybindSettingsPage({super.key});

  @override
  State<KeybindSettingsPage> createState() => _KeybindSettingsPageState();
}

class _KeybindSettingsPageState extends State<KeybindSettingsPage> {
  final InputHandler _inputHandler = InputHandler.instance;
  final Map<KeybindCategory, List<KeybindAction>> _actionsByCategory = {};

  @override
  void initState() {
    super.initState();
    _loadActionsByCategory();
  }

  void _loadActionsByCategory() {
    _actionsByCategory.clear();
    _actionsByCategory.addAll(_inputHandler.getActionsByCategory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keyboard & Controller Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to defaults',
            onPressed: _showResetDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildInfoCard(),
          Expanded(
            child: _buildKeybindsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.gamepad,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                'Meta Quest 3 Controller Support',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Configure keyboard shortcuts and controller buttons for enhanced VR/Quest 3 compatibility. '
            'These controls will work even when the application window is not focused.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                label: const Text('Global Input'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Chip(
                label: const Text('VR Ready'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Chip(
                label: const Text('Customizable'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeybindsList() {
    return ListView.builder(
      itemCount: _actionsByCategory.length,
      itemBuilder: (context, categoryIndex) {
        final category = _actionsByCategory.keys.elementAt(categoryIndex);
        final actions = _actionsByCategory[category]!;

        return ExpansionTile(
          title: Text(
            category.displayName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text('${actions.length} actions'),
          initiallyExpanded: categoryIndex == 0, // Expand first category by default
          children: actions.map((action) {
            return KeybindConfigWidget(
              action: action,
              onChanged: (_) => setState(() {}), // Refresh UI when keybind changes
            );
          }).toList(),
        );
      },
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => SettingsDialog(
        title: const Text('Reset to Defaults'),
        contentItems: const [
          Text('This will reset all keybinds to their default values. Are you sure?'),
        ],
        actionButtons: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _inputHandler.resetKeybindsToDefaults();
              _inputHandler.saveKeybinds();
              Navigator.of(context).pop();
              setState(() {}); // Refresh UI
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Keybinds reset to defaults'),
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

/// Instruction widget for showing how to use keybinds
class KeybindInstructionsWidget extends StatelessWidget {
  const KeybindInstructionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'How to Use',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInstructionItem(
              context,
              '1. Click the edit button next to any action',
              Icons.edit,
            ),
            _buildInstructionItem(
              context,
              '2. Press the desired key combination',
              Icons.keyboard,
            ),
            _buildInstructionItem(
              context,
              '3. The keybind will be saved automatically',
              Icons.save,
            ),
            _buildInstructionItem(
              context,
              '4. Use the clear button to remove a keybind',
              Icons.clear,
            ),
            const SizedBox(height: 8),
            Text(
              'Supported modifiers: Ctrl, Shift, Alt, Cmd/Meta',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(BuildContext context, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
