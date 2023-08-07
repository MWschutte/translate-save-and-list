import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:translate_save_and_list/database/database_provider.dart';
import 'package:translate_save_and_list/models/translation.dart';
import 'package:translate_save_and_list/pages/select_language_page.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _translationController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();
  TranslateLanguage sourceLanguage = TranslateLanguage.dutch;
  TranslateLanguage targetLanguage = TranslateLanguage.english;
  Timer? _debounce;
  final int _debounceTime = 500;
  final List<Translation> sessionWords = [];

  late OnDeviceTranslator onDeviceTranslator;

  @override
  void initState() {
    _translationController.text = "Translation";
    buildDeviceTranslator();
    super.initState();
  }

  void buildDeviceTranslator() {
    onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);
  }

  @override
  void dispose() {
    onDeviceTranslator.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
            floating: true,
            pinned: true,
            collapsedHeight: 180,
            expandedHeight: 350,
            flexibleSpace: Material(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  const Spacer(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ChangeLanguageButton(
                            onLanguageSelect: (newLanguage) => setState(() {
                                  sourceLanguage = newLanguage;
                                  buildDeviceTranslator();
                                }),
                            sourceLanguage: sourceLanguage),
                        IconButton(
                            onPressed: () => setState(() {
                                  TranslateLanguage temp = targetLanguage;
                                  targetLanguage = sourceLanguage;
                                  sourceLanguage = temp;
                                  buildDeviceTranslator();
                                }),
                            icon: const Icon(Icons.swap_horiz)),
                        ChangeLanguageButton(
                            sourceLanguage: targetLanguage,
                            onLanguageSelect: (newLanguage) => setState(() {
                                  targetLanguage = newLanguage;
                                  buildDeviceTranslator();
                                }))
                      ]),
                  const Divider(),
                  TextField(
                      controller: _inputController,
                      onChanged: _translateText,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        hintText: "Enter text",
                        contentPadding: EdgeInsets.all(8),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: TextField(
                        style: Theme.of(context).textTheme.titleLarge,
                        controller: _translationController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                        ),
                        readOnly: true),
                  )
                ]))),
        SliverList(
            delegate:
                SliverChildBuilderDelegate(childCount: sessionWords.length,
                    (BuildContext context, int pdIndex) {
          return HistoryListTile(
              translation: sessionWords[sessionWords.length - 1 - pdIndex]);
        }))
      ],
    );
  }

  void _translateText(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: _debounceTime), () {
      if (text != "") {
        _translationController.text = "Translating...";
        onDeviceTranslator
            .translateText(text)
            .then((value) => _handleTranslation(value));
      }
    });
  }

  void _handleTranslation(String value) {
    _translationController.text = value;
    Translation newWord = Translation(
        id: DateTime.now().millisecondsSinceEpoch,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        source: _inputController.text,
        translation: value,
        dateTime: DateTime.now());
    setState(() {
      sessionWords.add(newWord);
    });
    DatabaseProvider().insertTranslation(newWord);
  }

  @override
  bool get wantKeepAlive => true;
}

class HistoryListTile extends StatelessWidget {
  const HistoryListTile({
    required this.translation,
    super.key,
  });

  final Translation translation;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Text(translation.source,
            style: Theme.of(context).textTheme.bodyLarge),
        trailing: Text(translation.translation,
            style: Theme.of(context).textTheme.bodyLarge));
  }
}

class ChangeLanguageButton extends StatelessWidget {
  const ChangeLanguageButton({
    super.key,
    required this.onLanguageSelect,
    required this.sourceLanguage,
  });

  final ValueChanged<TranslateLanguage> onLanguageSelect;
  final TranslateLanguage sourceLanguage;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectLanguagePage(
                      selectedLanguage: sourceLanguage,
                      onLanguageSelect: onLanguageSelect)),
            ),
        child: Row(children: [
          Text(sourceLanguage.name),
          const Icon(Icons.expand_more)
        ]));
  }
}
