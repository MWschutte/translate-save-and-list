import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class Translation {
  final int id;
  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;
  final String source;
  final String translation;
  final DateTime dateTime;

  const Translation(
      {required this.id,
      required this.sourceLanguage,
      required this.targetLanguage,
      required this.source,
      required this.translation,
      required this.dateTime});

  Map<String, dynamic> toMap() => {
        'id': id,
        'sourceLanguage': sourceLanguage.bcpCode,
        'targetLanguage': targetLanguage.bcpCode,
        'source': source,
        'translation': translation,
        'dateTime': dateTime.toIso8601String()
      };

  factory Translation.fromMap(Map<String, dynamic> map) => Translation(
      id: map['id'] as int,
      sourceLanguage: BCP47Code.fromRawValue(map['sourceLanguage'])!,
      targetLanguage: BCP47Code.fromRawValue(map['targetLanguage'])!,
      source: map['source'],
      translation: map['translation'],
      dateTime: DateTime.parse(map['dateTime']));
}
