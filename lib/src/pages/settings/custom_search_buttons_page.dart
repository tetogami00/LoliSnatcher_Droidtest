import 'package:flutter/material.dart';

import 'package:lolisnatcher/src/handlers/settings_handler.dart';
import 'package:lolisnatcher/src/widgets/common/cancel_button.dart';
import 'package:lolisnatcher/src/widgets/common/confirm_button.dart';

class CustomSearchButtonsPage extends StatefulWidget {
  const CustomSearchButtonsPage({super.key});

  @override
  State<CustomSearchButtonsPage> createState() => _CustomSearchButtonsPageState();
}

class _CustomSearchButtonsPageState extends State<CustomSearchButtonsPage> {
  final SettingsHandler settingsHandler = SettingsHandler.instance;
  late List<Map<String, String>> customButtons;

  @override
  void initState() {
    super.initState();
    // Make a copy of the list to avoid modifying the original until save
    customButtons = List<Map<String, String>>.from(
      settingsHandler.customSearchButtons.map(Map<String, String>.from),
    );
    
    // Add default buttons if empty
    if (customButtons.isEmpty) {
      customButtons.addAll([
        {'name': 'NO VID', 'tags': '-animated -video'},
        {'name': 'SFW', 'tags': 'rating:safe'},
        {'name': 'NSFW', 'tags': 'rating:explicit OR rating:questionable'},
      ]);
    }
  }

  Future<void> _onPopInvoked(bool didPop, _) async {
    if (didPop) {
      return;
    }

    settingsHandler.customSearchButtons = customButtons;
    final bool result = await settingsHandler.saveSettings(restate: false);
    if (result) {
      Navigator.of(context).pop();
    }
  }

  void _addButton() {
    setState(() {
      customButtons.add({'name': '', 'tags': ''});
    });
  }

  void _removeButton(int index) {
    setState(() {
      customButtons.removeAt(index);
    });
  }

  void _editButton(int index) {
    final button = customButtons[index];
    final nameController = TextEditingController(text: button['name']);
    final tagsController = TextEditingController(text: button['tags']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Search Button'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Button Name',
                hintText: 'e.g., NO VID',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags to Add',
                hintText: 'e.g., -animated -video',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          const CancelButton(),
          ConfirmButton(
            action: () {
              setState(() {
                customButtons[index] = {
                  'name': nameController.text.trim(),
                  'tags': tagsController.text.trim(),
                };
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Search Buttons'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addButton,
              tooltip: 'Add Button',
            ),
          ],
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Create custom buttons that add specific tags to your search. These buttons will appear in the search interface.',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              child: customButtons.isEmpty
                  ? const Center(
                      child: Text(
                        'No custom buttons yet.\nTap the + button to add one.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: customButtons.length,
                      itemBuilder: (context, index) {
                        final button = customButtons[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            title: Text(
                              button['name']?.isNotEmpty == true
                                  ? button['name']!
                                  : 'Unnamed Button',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: button['name']?.isEmpty == true
                                    ? Colors.grey
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              button['tags']?.isNotEmpty == true
                                  ? button['tags']!
                                  : 'No tags specified',
                              style: TextStyle(
                                color: button['tags']?.isEmpty == true
                                    ? Colors.grey
                                    : null,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editButton(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _removeButton(index),
                                ),
                              ],
                            ),
                            onTap: () => _editButton(index),
                          ),
                        );
                      },
                    ),
            ),
        ],
        ),
      ),
    );
  }
}
