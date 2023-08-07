import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class SelectLanguagePage extends StatelessWidget {
  const SelectLanguagePage(
      {required this.selectedLanguage,
      required this.onLanguageSelect,
      super.key});

  final ValueChanged<TranslateLanguage> onLanguageSelect;
  final TranslateLanguage selectedLanguage;

  @override
  Widget build(BuildContext context) {
    List<TranslateLanguage> languages = TranslateLanguage.values;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Choose language"),
        ),
        body: ListView.builder(
            itemCount: languages.length,
            itemBuilder: (context, index) {
              TranslateLanguage language = languages[index];
              return ListTile(
                leading: language == selectedLanguage
                    ? const Icon(Icons.check)
                    : Container(
                        width: 10,
                      ),
                title: Text(languages[index].name),
                onTap: () {
                  onLanguageSelect(languages[index]);
                  Navigator.of(context).pop();
                },
              );
            }));
  }
}
