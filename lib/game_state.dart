import 'scoring.dart';

/// Manual scratchpad color applied by the player tapping on settled tiles.
enum TileScratchColor { none, red, yellow, green }

/// Overall game status.
enum GameStatus { loading, playing, calculating, won, lost }

/// Data for a single row in the 8-row grid.
class RowData {
  /// The 5 letters the user has typed (uppercase). Empty string means unfilled.
  /// Can also contain '_' as a structural placeholder.
  final List<String> letters;

  /// After submission, the scoring result for this row. Null if not yet submitted.
  ScoreResult? score;

  /// Manual scratchpad colors set by the user (tapping settled tiles to cycle).
  final List<TileScratchColor> scratchColors;

  /// Whether this row has been submitted and locked.
  bool isSettled;

  RowData()
      : letters = List.filled(5, ''),
        scratchColors = List.filled(5, TileScratchColor.none),
        isSettled = false;

  /// Resets this row to its initial empty state.
  void reset() {
    for (int i = 0; i < 5; i++) {
      letters[i] = '';
      scratchColors[i] = TileScratchColor.none;
    }
    score = null;
    isSettled = false;
  }

  /// Returns true if all 5 cells contain a letter (not empty, not '_').
  bool get isFull =>
      letters.every((l) => l.isNotEmpty && l != '_');

  /// Returns true if all 5 cells have content (letters or underscores).
  bool get isComplete => letters.every((l) => l.isNotEmpty);

  /// Builds the word string from the letters (e.g., "STARE").
  String get word => letters.join();
}

/// Root game state — mutated via setState() in the GameScreen widget.
class GameState {
  /// The secret word the player is trying to guess.
  String secretWord = '';

  /// Index of the currently active row (0–7).
  int activeRowIndex = 0;

  /// Cursor position within the active row (0–4).
  int activeCellIndex = 0;

  /// Current game status.
  GameStatus status = GameStatus.loading;

  /// The 8 rows of the game grid.
  final List<RowData> rows = List.generate(8, (_) => RowData());

  /// Letters globally locked as Red from the 5-Red auto-discard rule.
  /// These letters are grayed out on the keyboard and auto-colored red in all tiles.
  final Set<String> disabledLetters = {};

  /// Resets all state for a new game.
  void reset() {
    secretWord = '';
    activeRowIndex = 0;
    activeCellIndex = 0;
    status = GameStatus.loading;
    disabledLetters.clear();
    for (final row in rows) {
      row.reset();
    }
  }

  /// Returns the currently active row.
  RowData get activeRow => rows[activeRowIndex];
}
