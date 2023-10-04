import 'package:flutter/material.dart';
import 'package:translate_save_and_list/enums.dart';
import 'package:translate_save_and_list/mixins/language_pair_mixin.dart';
import 'package:translate_save_and_list/models/language_pair.dart';
import 'package:translate_save_and_list/pages/do_quiz_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with LanguagePairMixin {
  LanguagePair? selectedLanguagePair;
  QuizType selectedQuizType = QuizType.selectWord;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          DropdownMenu<LanguagePair>(
            width: 180,
            hintText: "Select language pair",
            dropdownMenuEntries: languagePairs
                .map((e) => DropdownMenuEntry(
                    label:
                        '${e.sourceLanguage.name} - ${e.targetLanguage.name}',
                    value: e))
                .toList(),
            onSelected: (LanguagePair? value) {
              if (value != null) {
                setState(() {
                  selectedLanguagePair = value;
                });
              }
            },
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                child: Text('Choose a Quiz type.',
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              Wrap(
                spacing: 5,
                children: QuizType.values
                    .map((QuizType quizType) => ChoiceChip(
                        label: Text(quizType.displayTitle),
                        selected: quizType == selectedQuizType,
                        onSelected: (_) => setState(() {
                              selectedQuizType = quizType;
                            })))
                    .toList(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: ElevatedButton(
                onPressed: _doQuiz, child: const Text('Do Quiz')),
          )
        ]));
  }

  void _doQuiz() {
    LanguagePair? slp = selectedLanguagePair;
    if (slp == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Select language pair in dropdown menu"),
      ));
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DoQuizPage(languagePair: slp, quizType: selectedQuizType)));
  }
}
