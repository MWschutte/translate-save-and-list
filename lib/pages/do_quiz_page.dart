import 'package:flutter/material.dart';
import 'package:translate_save_and_list/database/database_provider.dart';
import 'package:translate_save_and_list/enums.dart';
import 'package:translate_save_and_list/models/language_pair.dart';
import 'package:translate_save_and_list/models/translation.dart';

enum Correct { correct, incorrect, none }

class DoQuizPage extends StatefulWidget {
  const DoQuizPage(
      {required this.languagePair, required this.quizType, super.key});

  final LanguagePair languagePair;
  final QuizType quizType;

  @override
  State<DoQuizPage> createState() => _DoQuizPageState();
}

class _DoQuizPageState extends State<DoQuizPage> {
  List<Translation> quizWords = [];
  int numberOfQuizWords = 10;
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
    return List.generate(quizWords.length, (i) {
      Translation t = quizWords[i];
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            t.source,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        switch (widget.quizType) {
          QuizType.selectWord => SelectWord(
              correctWord: t.translation,
              languagePair: widget.languagePair,
              correct: _correct,
              textColor: _textColor,
              inputController: _inputController),
          QuizType.typeWord => TypeWord(
              inputController: _inputController,
              textColor: _textColor,
              correct: _correct)
        },
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text('$_selectedPageIndex/$numberOfQuizWords'),
          TextButton(onPressed: () => _check(i), child: const Text('check'))
        ]),
      ]);
    });
  }

  Future<void> _loadQuizWords() async {
    quizWords = await DatabaseProvider()
        .getNumberOfWords(numberOfQuizWords, widget.languagePair);
    setState(() {
      numberOfQuizWords = quizWords.length;
    });
  }

  Future<void> _check(int index) async {
    if (index >= numberOfQuizWords) return;
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
}

class TypeWord extends StatelessWidget {
  const TypeWord({
    super.key,
    required TextEditingController inputController,
    required Color textColor,
    required Correct correct,
  })  : _inputController = inputController,
        _textColor = textColor,
        _correct = correct;

  final TextEditingController _inputController;
  final Color _textColor;
  final Correct _correct;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: _inputController,
        style: TextStyle(color: _textColor),
        decoration: InputDecoration(
            hintText: "Enter solution",
            contentPadding: const EdgeInsets.all(10),
            suffix: _correct != Correct.none
                ? Icon(_correct == Correct.correct ? Icons.check : Icons.close,
                    color: _textColor)
                : null));
  }
}

class SelectWord extends StatefulWidget {
  const SelectWord(
      {required this.correctWord,
      required this.inputController,
      required this.textColor,
      required this.correct,
      required this.languagePair,
      super.key});

  final String correctWord;
  final TextEditingController inputController;
  final Color textColor;
  final Correct correct;
  final LanguagePair languagePair;

  @override
  State<SelectWord> createState() => _SelectWordState();
}

class _SelectWordState extends State<SelectWord> {
  int numberOfChoices = 5;
  List<String> choices = [];
  String? selectedItem;

  @override
  void initState() {
    _loadChoices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(children: [
              Container(
                  height: 90,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (selectedItem != null)
                        Expanded(
                          child: Wrap(
                            children: [
                              ActionChip(
                                  side: BorderSide(color: widget.textColor),
                                  label: Text(selectedItem ?? '',
                                      style:
                                          TextStyle(color: widget.textColor)),
                                  onPressed: () => setState(() {
                                        selectedItem = null;
                                        widget.inputController.text = '';
                                      })),
                            ],
                          ),
                        ),
                      if (widget.correct != Correct.none)
                        Icon(
                            widget.correct == Correct.correct
                                ? Icons.check
                                : Icons.close,
                            color: widget.textColor)
                    ],
                  )),
              const SizedBox(height: 25),
              Wrap(
                spacing: 5,
                children: choices
                    .map((name) => ActionChip(
                        label: Text(name),
                        onPressed: name != selectedItem
                            ? () => setState(() {
                                  selectedItem = name;
                                  widget.inputController.text = name;
                                })
                            : null))
                    .toList(),
              )
            ])));
  }

  Future<void> _loadChoices() async {
    List<Translation> translations = await DatabaseProvider()
        .getNumberOfWords(numberOfChoices , widget.languagePair);
    setState(() {
      choices = translations.map((Translation t) => t.translation).toList();
      if (!choices.contains(widget.correctWord)) {
        choices.removeAt(0);
        choices.add(widget.correctWord);
      }
      choices.shuffle();
    });
  }
}
