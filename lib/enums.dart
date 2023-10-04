
// enums

enum QuizType {
  selectWord,
  typeWord
}

enum LanguagePreference {
  source,
  target
}


// Shared preference keys.
const String themeModeSharedPreferenceKey = 'themeModePreference';


// Enum extensions.
extension QuizTypeExtension on QuizType {

  String get displayTitle {
    switch (this) {
      case QuizType.typeWord:
        return 'Type word';
      case QuizType.selectWord:
        return 'Select word';
    }
  }
}
