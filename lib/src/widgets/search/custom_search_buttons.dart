import 'package:flutter/material.dart';

import 'package:lolisnatcher/src/handlers/search_handler.dart';
import 'package:lolisnatcher/src/handlers/settings_handler.dart';

class CustomSearchButtons extends StatelessWidget {
  const CustomSearchButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsHandler settingsHandler = SettingsHandler.instance;
    final SearchHandler searchHandler = SearchHandler.instance;
    
    if (settingsHandler.customSearchButtons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: settingsHandler.customSearchButtons.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final button = settingsHandler.customSearchButtons[index];
          final name = button['name'] ?? '';
          final tags = button['tags'] ?? '';
          
          if (name.isEmpty || tags.isEmpty) {
            return const SizedBox.shrink();
          }
          
          return ElevatedButton(
            onPressed: () {
              final currentText = searchHandler.searchTextController.text;
              final newText = currentText.isEmpty 
                  ? tags 
                  : '$currentText $tags';
              
              searchHandler.searchTextController.text = newText;
              // Trigger search automatically
              searchHandler.searchAction(newText, null);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(0, 36),
            ),
            child: Text(
              name,
              style: const TextStyle(fontSize: 12),
            ),
          );
        },
      ),
    );
  }
}
