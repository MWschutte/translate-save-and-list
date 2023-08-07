import 'package:flutter/material.dart';
import 'package:translate_save_and_list/database/database_provider.dart';
import 'package:translate_save_and_list/pages/quiz_page.dart';
import 'package:translate_save_and_list/pages/list_page.dart';
import 'package:translate_save_and_list/pages/translation_page.dart';
import 'package:flutter/widgets.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  await DatabaseProvider().createDatabase();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translate save and list',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<String> _widgetTitles = <String>['Translate', 'Quiz', 'List'];
  static const List<Widget> _widgetOptions = <Widget>[
    TranslationPage(),
    QuizPage(),
    ListPage()
  ];

  late PageController _pageController;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_widgetTitles[_selectedPageIndex]),
      ),
      body: Center(
        child: PageView(
            controller: _pageController,
            children: _widgetOptions,
            onPageChanged: (page) => setState(() {
                  _selectedPageIndex = page;
                })),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'Translate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
        ],
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
