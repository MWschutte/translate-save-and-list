import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:translate_save_and_list/database/database_provider.dart';
import 'package:translate_save_and_list/models/Translation.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Translation> translations = [];

  @override
  void initState() {
    fetchTranslations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: translations.length,
      prototypeItem: const ListTile(
        title: Text('translation'),
      ),
      itemBuilder: (context, index) {
        return TranslationListTile(translation: translations[index]);
      },
    );
  }

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
      title: Text(translation.source),
      leading: Text('${translation.sourceLanguage.bcpCode} ~ ${translation.targetLanguage.bcpCode}'),
      subtitle: Text(translation.dateTime.toString()),
      trailing: Text(translation.translation),
    );
  }
}
