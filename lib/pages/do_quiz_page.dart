import 'package:flutter/material.dart';
import 'package:translate_save_and_list/database/database_provider.dart';
import 'package:translate_save_and_list/models/language_pair.dart';
import 'package:translate_save_and_list/models/translation.dart';

enum Correct { correct, incorrect, none }

class DoQuizPage extends StatefulWidget {
  const DoQuizPage({required this.languagePair, super.key});

  final LanguagePair languagePair;

  @override
  State<DoQuizPage> createState() => _DoQuizPageState();
}

class _DoQuizPageState extends State<DoQuizPage> {
  List<Translation> quizWords = [];
  final int numberOfQuizWords = 10;
  final PageController _pageController = PageController();
  int _selectedPageIndex = 0;
  Correct _correct = Correct.none;
  final TextEditingController _inputController = TextEditingController();
  Color _textColor = Colors.black;

  @override
  void initState() {
    _loadQuizWords();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(
                'Quiz: ${widget.languagePair.sourceLanguage.name} - ${widget.languagePair.targetLanguage.name}')),
        body: PageView(
            controller: _pageController,
            children: _widgetOptions(),
            onPageChanged: (page) => setState(() {
                  _selectedPageIndex = page;
                })));
  }

  List<Widget> _widgetOptions() {
    return List.generate(
        quizWords.length,
        (i) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                quizWords[i].source,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextField(
                  controller: _inputController,
                  style: TextStyle(color: _textColor),
                  decoration: InputDecoration(
                      hintText: "Enter solution",
                      contentPadding: const EdgeInsets.all(10),
                      suffix: _correct != Correct.none
                          ? Icon(_correct == Correct.correct ? Icons.check : Icons.close, color: _textColor)
                          : null)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('$_selectedPageIndex/$numberOfQuizWords'),
                TextButton(
                    onPressed: () => _check(i), child: const Text('check'))
              ]),
            ]));
  }

  Future<void> _loadQuizWords() async {
    List<Translation> translations =
        await DatabaseProvider().listTranslations();
    List<Translation> filteredTranslations = translations
        .where((element) => _sameAsSelectedLanguagePair(element))
        .toList();
    filteredTranslations.shuffle();
    setState(() {
      quizWords = filteredTranslations.sublist(0, numberOfQuizWords);
    });
  }

  Future<void> _check(int index) async {
    Translation quizWord = quizWords[index];
    setState(() {
      if (_inputController.text == quizWord.translation) {
        _correct = Correct.correct;
        _textColor = Colors.lightGreenAccent;
      } else {
        _correct = Correct.incorrect;
        _textColor = Colors.redAccent;
        _inputController.text = quizWord.translation;
      }
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _selectedPageIndex = _selectedPageIndex + 1;
      _pageController.jumpToPage(_selectedPageIndex);
      _correct = Correct.none;
      _inputController.text = '';
      _textColor = Colors.black;
    });
  }

  bool _sameAsSelectedLanguagePair(Translation element) {
    LanguagePair selectedLanguage = widget.languagePair;
    return element.targetLanguage == selectedLanguage.targetLanguage &&
        element.sourceLanguage == selectedLanguage.sourceLanguage;
  }
}
