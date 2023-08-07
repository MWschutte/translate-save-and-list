import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class Translation {
  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;
  final String source;
  final String translation;

  const Translation(
      {required this.sourceLanguage,
      required this.targetLanguage,
      required this.source,
      required this.translation});
}
