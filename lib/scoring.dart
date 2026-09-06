/// Scoring result for a single guess against the secret word.
class ScoreResult {
  /// Number of letters in the exact correct position.
  final int green;

  /// Number of letters that exist in the secret word but are misplaced.
  final int yellow;

  /// Number of letters that do not exist in the secret word at all.
  final int red;

  const ScoreResult({
    required this.green,
    required this.yellow,
    required this.red,
  });

  /// True when all 5 letters are exact matches — player wins.
  bool get isWin => green == 5;

  /// True when all 5 letters are incorrect — triggers auto-discard sweep.
  bool get isAllRed => red == 5;

  @override
  String toString() => 'ScoreResult(green: $green, yellow: $yellow, red: $red)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreResult &&
          green == other.green &&
          yellow == other.yellow &&
          red == other.red;

  @override
  int get hashCode => Object.hash(green, yellow, red);
}

/// Scores a [guess] against the [secret] word using the **uncapped** algorithm.
///
/// Each character of the guess is evaluated independently:
/// - If `guess[i] == secret[i]` → **Green** (exact match).
/// - Else if `guess[i]` exists anywhere in [secret] → **Yellow** (misplaced).
/// - Else → **Red** (not in the secret word at all).
///
/// This is "uncapped" because a letter that appears once in the secret
/// can generate multiple Yellow/Green counts if the guess repeats it.
ScoreResult scoreGuess(String guess, String secret) {
  assert(guess.length == 5, 'Guess must be 5 characters');
  assert(secret.length == 5, 'Secret must be 5 characters');

  int green = 0;
  int yellow = 0;
  int red = 0;

  final secretChars = secret.split('');

  for (int i = 0; i < 5; i++) {
    if (guess[i] == secret[i]) {
      green++;
    } else if (secretChars.contains(guess[i])) {
      yellow++;
    } else {
      red++;
    }
  }

  return ScoreResult(green: green, yellow: yellow, red: red);
}
