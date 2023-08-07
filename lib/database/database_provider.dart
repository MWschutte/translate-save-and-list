import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:translate_save_and_list/models/translation.dart';
import 'package:translate_save_and_list/models/language_pair.dart';

class DatabaseProvider {
  Database? database;
  final String _translations = 'translations';

  static final DatabaseProvider _databaseProvider = DatabaseProvider._internal();

  factory DatabaseProvider() {
    return _databaseProvider;
  }

  DatabaseProvider._internal();

  Future<void> createDatabase() async {
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'translation_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE translations(id INTEGER PRIMARY KEY, sourceLanguage TEXT,  targetLanguage TEXT, source TEXT, translation TEXT, dateTime TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertTranslation(Translation translation) async {
    // Get a reference to the database.
    Database? db = database;
    if (db == null) return;
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      _translations,
      translation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Translation>> listTranslations() async {
    // Query the table for all The Dogs.
    Database? db = database;
    if (db == null) return [];
    final List<Map<String, dynamic>> maps = await db.query(_translations);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Translation.fromMap(maps[i]);
    });
  }

  Future<List<LanguagePair>> listLanguagePairs() async {
  Database? db = database;
  if (db == null) return [];
  final List<Map<String, dynamic>> maps = await db.query(_translations, columns: ['sourceLanguage', 'targetLanguage'], distinct: true);

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
  return LanguagePair.fromMap(maps[i]);
  });
}

}