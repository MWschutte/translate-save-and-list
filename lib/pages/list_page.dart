import 'package:flutter/material.dart';
import 'package:translate_save_and_list/database/database_provider.dart';
import 'package:translate_save_and_list/models/Translation.dart';
import 'package:translate_save_and_list/models/language_pair.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Translation> translations = [];
  List<LanguagePair> languagePairs = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: _buildSlivers());
  }

  List<Widget> _buildSlivers () {
    List<Widget> slivers = [];
    for (LanguagePair languagePair in languagePairs) {
      slivers.add(SliverAppBar(
        pinned: true,
        toolbarHeight: 30,
        title: Text('${languagePair.sourceLanguage.name} - ${languagePair.targetLanguage.name}'),
      ));
      List<Translation> filteredList = translations.where((translation) => translation.sourceLanguage == languagePair.sourceLanguage && translation.targetLanguage == languagePair.targetLanguage).toList();
      slivers.add(
          SliverList(
              delegate: SliverChildBuilderDelegate(childCount: filteredList.length,
                      (context, index) {
                    return TranslationListTile(translation: filteredList[index]);
                  }))
      );
    }
    return slivers;
  }



  void fetchData() {
    fetchLanguagePairs();
    fetchTranslations();
  }

  Future<void> fetchLanguagePairs() => DatabaseProvider()
      .listLanguagePairs()
      .then((fetchedLanguagePairs) => setState(() {
            languagePairs = fetchedLanguagePairs;
          }));

  Future<void> fetchTranslations() => DatabaseProvider()
      .listTranslations()
      .then((fetchedTranslations) => setState(() {
            translations = fetchedTranslations;
          }));
}

class TranslationListTile extends StatelessWidget {
  const TranslationListTile({
    super.key,
    required this.translation,
  });

  final Translation translation;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(translation.source,
              style: Theme.of(context).textTheme.bodyLarge),
          Text(translation.translation,
              style: Theme.of(context).textTheme.bodyLarge)
        ],
      ),
      // trailing: Text('${translation.sourceLanguage.bcpCode} ~ ${translation.targetLanguage.bcpCode}'),
    );
  }
}
