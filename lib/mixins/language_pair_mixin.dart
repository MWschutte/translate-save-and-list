
import 'package:flutter/material.dart';
import 'package:translate_save_and_list/database/database_provider.dart';
import 'package:translate_save_and_list/models/language_pair.dart';

mixin LanguagePairMixin<T extends StatefulWidget> on State<T> {
  List<LanguagePair> languagePairs = [];

  Future<void> fetchLanguagePairs() => DatabaseProvider()
      .listLanguagePairs()
      .then((fetchedLanguagePairs) => setState(() {
    languagePairs = fetchedLanguagePairs;
  }));

  @override
  void initState() {
    fetchLanguagePairs();
    super.initState();
  }
}
