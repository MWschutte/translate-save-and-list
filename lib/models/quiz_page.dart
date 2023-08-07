import 'package:flutter/material.dart';
import 'package:translate_save_and_list/mixins/language_pair_mixin.dart';
import 'package:translate_save_and_list/models/language_pair.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with LanguagePairMixin {
  LanguagePair? selectedLanguagePair;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      DropdownButton<LanguagePair>(
        hint: const Text("Select language pair"),
        value: selectedLanguagePair,
        icon: const Icon(Icons.expand_more),
        elevation: 16,
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (LanguagePair? value) {
          if (value != null) {
            setState(() {
              selectedLanguagePair = value;
            });
          }
        },
        items: languagePairs
            .map<DropdownMenuItem<LanguagePair>>((LanguagePair value) {
          return DropdownMenuItem<LanguagePair>(
            value: value,
            child: Text(
                '${value.sourceLanguage.name} - ${value.targetLanguage.name}'),
          );
        }).toList(),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: ElevatedButton(onPressed: () {}, child: const Text('Do Quiz')),
      )
    ]));
  }
}
