import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translate_save_and_list/database/database_provider.dart';
import 'package:translate_save_and_list/pages/quiz_page.dart';
import 'package:translate_save_and_list/pages/list_page.dart';
import 'package:translate_save_and_list/pages/translation_page.dart';
import 'package:flutter/widgets.dart';

import 'enums.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  await DatabaseProvider().createDatabase();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? themeModeIndex = prefs.getInt(themeModeSharedPreferenceKey);
  ThemeMode themeMode = themeModeIndex == null ? ThemeMode.system: ThemeMode.values[themeModeIndex];
  runApp(MyApp(initialTheme: themeMode));
}

class MyApp extends StatefulWidget {
  const MyApp({required this.initialTheme, super.key});
  final ThemeMode initialTheme;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    _themeMode = widget.initialTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translate save and list',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple[900]!,
              background: const Color(0xff03002e),
              brightness: Brightness.dark,
              shadow: Colors.pink[50]),
          useMaterial3: true),
      themeMode: _themeMode,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    _saveThemePreference(themeMode);
  }

  Future<void> _saveThemePreference(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(themeModeSharedPreferenceKey, themeMode.index);
  }

  ThemeMode get getTheme => _themeMode;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<String> _widgetTitles = <String>[
    'Translate',
    'Quiz',
    'List'
  ];
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
        endDrawer: Drawer(
            child: Column(children: [
          const SizedBox(height: 150),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Color theme', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(width: 10),
              Icon(_darkModeEnabled()? Icons.dark_mode_outlined: Icons.light_mode_outlined)
            ],
          ),
          const ChangeTheme()
        ])));
  }

  bool _darkModeEnabled(){
    _MyAppState? appState = _MyAppState.of(context);
    ThemeMode theme = appState?.getTheme ?? ThemeMode.system;
    if (theme==ThemeMode.system) {
      Brightness brightness = MediaQuery
          .of(context)
          .platformBrightness;
      return brightness == Brightness.dark;
    }
    return theme == ThemeMode.dark;
  }
}

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({
    super.key,
  });

  @override
  State<ChangeTheme> createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
  @override
  Widget build(BuildContext context) {
    _MyAppState? appState = _MyAppState.of(context);
    ThemeMode theme = appState?.getTheme ?? ThemeMode.system;
    return Wrap(
        spacing: 5,
        children: ThemeMode.values
            .map((e) => ChoiceChip(
                label: Text(e.name),
                selected: e.index == theme.index,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      appState?.changeTheme(e);
                    });
                  }
                }))
            .toList());
  }
}
