import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../dictionary.dart';
import '../game_state.dart';
import '../scoring.dart';
import '../services/word_cache.dart';
import '../widgets/game_dialogs.dart';
import '../widgets/game_grid.dart';
import '../widgets/keyboard_panel.dart';
import '../widgets/shake_animation.dart';

/// Main game screen — orchestrates the 8-row grid, keyboard input,
/// scoring, scratchpad, and game lifecycle.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameState _game = GameState();
  final Random _random = Random();

  /// One ShakeWidgetState key per row to trigger shake on invalid guesses.
  late final List<GlobalKey<ShakeWidgetState>> _shakeKeys;

  @override
  void initState() {
    super.initState();
    _shakeKeys = List.generate(kMaxRows, (_) => GlobalKey<ShakeWidgetState>());
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    _selectSecretWord();
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  // ─── Secret Word Selection ──────────────────────────────────────────────

  Future<void> _selectSecretWord() async {
    final recentWords = await WordCache.getRecentWords();
    final candidates =
        validSecrets.where((w) => !recentWords.contains(w)).toList();

    final secret = candidates[_random.nextInt(candidates.length)];
    await WordCache.addWord(secret);

    if (!mounted) return;
    setState(() {
      _game.secretWord = secret;
      _game.status = GameStatus.playing;
    });

    debugPrint('🎯 Secret word: $secret'); // Debug only — remove in production.
  }

  // ─── Hardware Keyboard Handler ──────────────────────────────────────────

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return false;
    if (_game.status != GameStatus.playing) return false;

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.backspace) {
      _deleteLetter();
      return true;
    }
    if (key == LogicalKeyboardKey.enter) {
      _submitGuess();
      return true;
    }
    if (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.minus) {
      _insertPlaceholder();
      return true;
    }

    // A-Z letter keys.
    final label = event.character;
    if (label != null && label.length == 1 && RegExp(r'[a-zA-Z]').hasMatch(label)) {
      _insertLetter(label.toUpperCase());
      return true;
    }

    return false;
  }

  // ─── Input Actions ──────────────────────────────────────────────────────

  void _insertLetter(String letter) {
    if (_game.status != GameStatus.playing) return;

    final row = _game.activeRow;
    if (_game.activeCellIndex >= kWordLength) return;

    setState(() {
      row.letters[_game.activeCellIndex] = letter;
      if (_game.activeCellIndex < kWordLength) {
        _game.activeCellIndex++;
      }
    });
  }

  void _insertPlaceholder() {
    _insertLetter('_');
  }

  void _deleteLetter() {
    if (_game.status != GameStatus.playing) return;
    if (_game.activeCellIndex <= 0) return;

    setState(() {
      _game.activeCellIndex--;
      _game.activeRow.letters[_game.activeCellIndex] = '';
    });
  }

  // ─── Guess Submission ───────────────────────────────────────────────────

  Future<void> _submitGuess() async {
    if (_game.status != GameStatus.playing) return;

    final row = _game.activeRow;

    // Must have 5 cells filled.
    if (!row.isComplete) return;

    // Must not contain underscore placeholders.
    if (!row.isFull) {
      _shakeActiveRow();
      return;
    }

    final word = row.word;

    // Anti-gibberish: check dictionary.
    if (!validGuesses.contains(word)) {
      _shakeActiveRow();
      return;
    }

    // Score the guess.
    final score = scoreGuess(word, _game.secretWord);

    // 1. Lock the row and block input
    setState(() {
      row.isSettled = true;
      _game.status = GameStatus.calculating;
    });

    // 2. Short delay before starting the spin animation
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // 3. Set the score. This triggers the AnimatedScoreTile slot machine animations.
    setState(() {
      row.score = score;
    });

    // 4. Wait for the staggered animations to complete (600ms base + 300ms max delay)
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    setState(() {
      // 5-Red auto-discard: globally lock all letters in this guess.
      if (score.isAllRed) {
        for (final letter in word.split('')) {
          _game.disabledLetters.add(letter);
        }
        // Sweep ALL settled rows: force-color disabled letters to red.
        _sweepDisabledLetters();
      }

      // Check win.
      if (score.isWin) {
        _game.status = GameStatus.won;
        _showWinDialog();
        return;
      }

      // Check loss (exhausted all 8 rows).
      if (_game.activeRowIndex >= kMaxRows - 1) {
        _game.status = GameStatus.lost;
        _showLossDialog();
        return;
      }

      // Advance to next row.
      _game.activeRowIndex++;
      _game.activeCellIndex = 0;
      _game.status = GameStatus.playing;
    });
  }

  /// Sweeps all settled rows and forces any tile containing a disabled letter
  /// to scratchColor = red.
  void _sweepDisabledLetters() {
    for (final row in _game.rows) {
      if (!row.isSettled) continue;
      for (int i = 0; i < kWordLength; i++) {
        if (_game.disabledLetters.contains(row.letters[i])) {
          row.scratchColors[i] = TileScratchColor.red;
        }
      }
    }
  }

  void _shakeActiveRow() {
    _shakeKeys[_game.activeRowIndex].currentState?.shake();
  }

  // ─── Scratchpad Color Cycling ───────────────────────────────────────────

  void _onTileTap(int rowIndex, int cellIndex) {
    final row = _game.rows[rowIndex];
    if (!row.isSettled) return;

    final letter = row.letters[cellIndex];
    // Don't allow cycling on auto-locked 5-Red letters.
    if (_game.disabledLetters.contains(letter)) return;

    setState(() {
      // Cycle: none → red → yellow → green → none
      final current = row.scratchColors[cellIndex];
      row.scratchColors[cellIndex] = switch (current) {
        TileScratchColor.none => TileScratchColor.red,
        TileScratchColor.red => TileScratchColor.yellow,
        TileScratchColor.yellow => TileScratchColor.green,
        TileScratchColor.green => TileScratchColor.none,
      };
    });
  }

  /// Eraser: resets all manual scratchpad colors back to none.
  /// Does NOT reset auto-locked 5-Red letters.
  void _onErase() {
    setState(() {
      for (final row in _game.rows) {
        if (!row.isSettled) continue;
        for (int i = 0; i < kWordLength; i++) {
          if (!_game.disabledLetters.contains(row.letters[i])) {
            row.scratchColors[i] = TileScratchColor.none;
          }
        }
      }
    });
  }

  // ─── Game Lifecycle ─────────────────────────────────────────────────────

  void _showWinDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showWinDialog(context, _game.activeRowIndex + 1, _resetGame);
    });
  }

  void _showLossDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showLossDialog(context, _game.secretWord, _resetGame);
    });
  }

  void _resetGame() {
    setState(() {
      _game.reset();
      _shakeKeys.clear();
      _shakeKeys.addAll(
          List.generate(kMaxRows, (_) => GlobalKey<ShakeWidgetState>()));
    });
    _selectSecretWord();
  }

  // ─── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_game.status == GameStatus.loading) {
      return Scaffold(
        backgroundColor: kBrandDark,
        body: const Center(
          child: CircularProgressIndicator(color: kTileGreen),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBrandDark,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 8),

                  // Game grid (takes remaining space)
                  Expanded(
                    child: GameGrid(
                      gameState: _game,
                      shakeKeys: _shakeKeys,
                      onTileTap: _onTileTap,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // On-screen keyboard
                  KeyboardPanel(
                    disabledLetters: _game.disabledLetters,
                    onLetterTap: _insertLetter,
                    onBackspace: _deleteLetter,
                    onSpace: _insertPlaceholder,
                    onSubmit: _submitGuess,
                    onErase: _onErase,
                    enabled: _game.status == GameStatus.playing,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Back button
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white.withValues(alpha: 0.6),
          ),
          splashRadius: 20,
        ),
        const Expanded(
          child: Text(
            'Guess The Word',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
        // Spacer to balance the back button.
        const SizedBox(width: 48),
      ],
    );
  }
}
