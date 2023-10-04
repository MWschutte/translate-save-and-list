import 'package:flutter/material.dart';
import 'package:translate_save_and_list/database/database_provider.dart';
import 'package:translate_save_and_list/mixins/language_pair_mixin.dart';
import 'package:translate_save_and_list/mixins/translation_list_mixin.dart';
import 'package:translate_save_and_list/models/translation.dart';
import 'package:translate_save_and_list/models/language_pair.dart';
import 'package:translate_save_and_list/widgets/history_list_tile.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with LanguagePairMixin<ListPage>, TranslationListMixin<ListPage>{


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: _buildSlivers());
  }

  List<Widget> _buildSlivers () {
    List<Widget> slivers = [];
    for (LanguagePair languagePair in languagePairs) {
      slivers.add(SliverAppBar(
        pinned: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[Container()],
        toolbarHeight: 30,
        title: Text('${languagePair.sourceLanguage.name} - ${languagePair.targetLanguage.name}'),
      ));
      List<Translation> filteredList = translations.where((translation) => translation.sourceLanguage == languagePair.sourceLanguage && translation.targetLanguage == languagePair.targetLanguage).toList();
      slivers.add(
          SliverList(
              delegate: SliverChildBuilderDelegate(childCount: filteredList.length,
                      (context, index) {
                    Translation translation = filteredList[index];
                    return HistoryListTile(translation: translation, onDismissed: (_){
                      filteredList.remove(translation);
                      DatabaseProvider().deleteTranslation(translation);
                    });
                  }))
      );
    }
    return slivers;
  }
}
