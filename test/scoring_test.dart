import 'package:flutter_test/flutter_test.dart';
import 'package:guess_word_game/scoring.dart';

void main() {
  group('scoreGuess — uncapped algorithm', () {
    test('perfect match returns 5 greens', () {
      expect(scoreGuess('REACT', 'REACT'), const ScoreResult(green: 5, yellow: 0, red: 0));
      expect(scoreGuess('GAMER', 'GAMER'), const ScoreResult(green: 5, yellow: 0, red: 0));
      expect(scoreGuess('CRANE', 'CRANE'), const ScoreResult(green: 5, yellow: 0, red: 0));
    });

    test('all wrong returns 5 reds', () {
      expect(scoreGuess('WHISK', 'REACT'), const ScoreResult(green: 0, yellow: 0, red: 5));
    });

    test('uncapped scoring — EERIE vs REACT', () {
      // Secret: R E A C T
      // Guess:  E E R I E
      // E(0) vs R → exists in REACT → Yellow
      // E(1) vs E → exact match → Green
      // R(2) vs A → exists in REACT → Yellow
      // I(3) vs C → not in REACT → Red
      // E(4) vs T → exists in REACT → Yellow
      expect(scoreGuess('EERIE', 'REACT'), const ScoreResult(green: 1, yellow: 3, red: 1));
    });

    test('STARE vs GAMER — 0 green, 3 yellow, 2 red', () {
      // Secret: G A M E R
      // Guess:  S T A R E
      // S vs G → not in GAMER → Red
      // T vs A → not in GAMER → Red
      // A vs M → exists in GAMER → Yellow
      // R vs E → exists in GAMER → Yellow
      // E vs R → exists in GAMER → Yellow
      expect(scoreGuess('STARE', 'GAMER'), const ScoreResult(green: 0, yellow: 3, red: 2));
    });

    test('reversed word — EDCBA vs ABCDE', () {
      // Secret: A B C D E
      // Guess:  E D C B A
      // E(0) vs A → exists → Yellow
      // D(1) vs B → exists → Yellow
      // C(2) vs C → exact → Green
      // B(3) vs D → exists → Yellow
      // A(4) vs E → exists → Yellow
      expect(scoreGuess('EDCBA', 'ABCDE'), const ScoreResult(green: 1, yellow: 4, red: 0));
    });

    test('NNNNN vs CRANE — uncapped repeated letters', () {
      // Secret: C R A N E
      // Guess:  N N N N N
      // N(0) vs C → exists in CRANE → Yellow
      // N(1) vs R → exists in CRANE → Yellow
      // N(2) vs A → exists in CRANE → Yellow
      // N(3) vs N → exact match → Green
      // N(4) vs E → exists in CRANE → Yellow
      expect(scoreGuess('NNNNN', 'CRANE'), const ScoreResult(green: 1, yellow: 4, red: 0));
    });

    test('partial match — BARFS vs GAMER', () {
      // Secret: G A M E R
      // Guess:  B A R F S
      // B vs G → not in GAMER → Red
      // A vs A → exact → Green
      // R vs M → exists in GAMER → Yellow
      // F vs E → not in GAMER → Red
      // S vs R → not in GAMER → Red
      expect(scoreGuess('BARFS', 'GAMER'), const ScoreResult(green: 1, yellow: 1, red: 3));
    });

    test('GHOST vs GAMER — 1 green, 0 yellow, 4 red', () {
      // Secret: G A M E R
      // Guess:  G H O S T
      // G vs G → exact → Green
      // H vs A → not in GAMER → Red
      // O vs M → not in GAMER → Red
      // S vs E → not in GAMER → Red
      // T vs R → not in GAMER → Red
      expect(scoreGuess('GHOST', 'GAMER'), const ScoreResult(green: 1, yellow: 0, red: 4));
    });

    test('CURAT vs GAMER — 0 green, 2 yellow, 3 red', () {
      // Secret: G A M E R
      // Guess:  C U R A T
      // C vs G → not in GAMER → Red
      // U vs A → not in GAMER → Red
      // R vs M → exists in GAMER → Yellow
      // A vs E → exists in GAMER → Yellow
      // T vs R → not in GAMER → Red
      expect(scoreGuess('CURAT', 'GAMER'), const ScoreResult(green: 0, yellow: 2, red: 3));
    });
  });

  group('ScoreResult properties', () {
    test('isWin is true when green == 5', () {
      expect(const ScoreResult(green: 5, yellow: 0, red: 0).isWin, isTrue);
      expect(const ScoreResult(green: 4, yellow: 1, red: 0).isWin, isFalse);
    });

    test('isAllRed is true when red == 5', () {
      expect(const ScoreResult(green: 0, yellow: 0, red: 5).isAllRed, isTrue);
      expect(const ScoreResult(green: 0, yellow: 1, red: 4).isAllRed, isFalse);
    });

    test('equality works correctly', () {
      expect(
        const ScoreResult(green: 1, yellow: 3, red: 1),
        equals(const ScoreResult(green: 1, yellow: 3, red: 1)),
      );
    });
  });
}
