import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:translate_save_and_list/models/translation.dart';

class HistoryListTile extends StatelessWidget {
  const HistoryListTile({
    required this.translation,
    this.onDismissed,
    super.key,
  });

  final Translation translation;
  final DismissDirectionCallback? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(color: Colors.red),
        confirmDismiss: (_) async {
          bool? delete = await showDialog<bool?>(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Are you sure?"),
                    content: RichText(
                        text: TextSpan(
                            text: 'Deleting wil remove ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                          TextSpan(
                              text: translation.source,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: ' from the list'),
                          TextSpan(
                              text:
                                  ' ${translation.sourceLanguage.bcpCode} - ${translation.targetLanguage.bcpCode}',
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic)),
                          const TextSpan(text: '.')
                        ])),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'))
                    ],
                  ));
          return delete?? false;
        },
        onDismissed: onDismissed,
        key: Key(translation.id.toString()),
        child: ListTile(
          dense: false,
          title: Text(translation.source),
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          subtitle: Text(translation.translation),
          subtitleTextStyle: Theme.of(context).textTheme.bodyMedium,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
          minVerticalPadding: 0,
        ));
  }
}
