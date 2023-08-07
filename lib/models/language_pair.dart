import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class LanguagePair {
  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;

  const LanguagePair(
      {required this.sourceLanguage, required this.targetLanguage});

  factory LanguagePair.fromMap(Map<String, dynamic> map) => LanguagePair(
      sourceLanguage: BCP47Code.fromRawValue(map['sourceLanguage'])!,
      targetLanguage: BCP47Code.fromRawValue(map['targetLanguage'])!);
}
