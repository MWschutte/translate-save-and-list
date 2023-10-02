import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class SelectLanguagePage extends StatefulWidget {
  const SelectLanguagePage(
      {required this.selectedLanguage,
      required this.onLanguageSelect,
      super.key});

  final ValueChanged<TranslateLanguage> onLanguageSelect;
  final TranslateLanguage selectedLanguage;

  @override
  State<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  String filterString = '';

  @override
  Widget build(BuildContext context) {
    List<TranslateLanguage> languages = TranslateLanguage.values
        .where((element) => element.name.startsWith(filterString))
        .toList();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Choose language"),
        ),
        body: Column(children: [
          TextField(
              onChanged: (value) => setState(() {
                    filterString = value;
                  }),
              decoration: const InputDecoration(
                  hintText: 'Search in list',
                  contentPadding: EdgeInsets.all(8),
                  suffixIcon: Icon(Icons.search))),
          Expanded(
              child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    TranslateLanguage language = languages[index];
                    return ListTile(
                        leading: language == widget.selectedLanguage
                            ? const Icon(Icons.check)
                            : Container(
                                width: 10,
                              ),
                        title: Text(languages[index].name),
                        onTap: () {
                          widget.onLanguageSelect(languages[index]);
                          Navigator.of(context).pop();
                        });
                  }))
        ]));
  }
}
