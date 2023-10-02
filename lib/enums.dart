
enum QuizType {
  selectWord,
  typeWord
}

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