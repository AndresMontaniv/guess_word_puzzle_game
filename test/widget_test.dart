import 'package:flutter_test/flutter_test.dart';
import 'package:guess_word_game/dictionary.dart';

void main() {
  group('Dictionary data integrity', () {
    test('validSecrets are all 5-letter isograms', () {
      for (final word in validSecrets) {
        expect(word.length, 5, reason: '$word is not 5 letters');
        expect(word, equals(word.toUpperCase()), reason: '$word is not uppercase');
        expect(
          word.split('').toSet().length,
          5,
          reason: '$word has repeating letters — not an isogram',
        );
      }
    });

    test('all validSecrets are in validGuesses', () {
      for (final word in validSecrets) {
        expect(validGuesses.contains(word), isTrue,
            reason: '$word is in validSecrets but not in validGuesses');
      }
    });

    test('validGuesses contains common test words', () {
      expect(validGuesses.contains('SPEED'), isTrue);
      expect(validGuesses.contains('HELLO'), isTrue);
      expect(validGuesses.contains('REACT'), isTrue);
      expect(validGuesses.contains('GAMER'), isTrue);
      expect(validGuesses.contains('STARE'), isTrue);
      expect(validGuesses.contains('CRANE'), isTrue);
    });

    test('validGuesses all are 5 letters and uppercase', () {
      for (final word in validGuesses) {
        expect(word.length, 5, reason: '$word is not 5 letters');
        expect(word, equals(word.toUpperCase()), reason: '$word is not uppercase');
      }
    });

    test('validSecrets has substantial size', () {
      expect(validSecrets.length, greaterThan(3000));
    });

    test('validGuesses has substantial size', () {
      expect(validGuesses.length, greaterThan(8000));
    });
  });
}
