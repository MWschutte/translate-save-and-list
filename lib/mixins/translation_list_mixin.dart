

import 'package:flutter/material.dart';
import 'package:translate_save_and_list/database/database_provider.dart';
import 'package:translate_save_and_list/models/translation.dart';

mixin TranslationListMixin <T extends StatefulWidget> on State<T> {
  List<Translation> translations = [];

  Future<void> fetchTranslations() => DatabaseProvider()
      .listTranslations()
      .then((fetchedTranslations) => setState(() {
    translations = fetchedTranslations;
  }));

  @override
  void initState() {
    fetchTranslations();
    super.initState();
  }
}