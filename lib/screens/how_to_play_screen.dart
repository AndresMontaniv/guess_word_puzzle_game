import 'package:flutter/material.dart';
import '../constants.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrandDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button aligned with content
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back, color: Colors.white.withValues(alpha: 0.6)),
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'How to play Guess The Word?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('The Rules'),
                  _buildText('Guess the secret word in 8 attempts or less.'),
                  _buildText(
                      'After each guess, the three colored tiles on the right (green, yellow, red) show how many letters of your guess are in the secret word, and how many are in the right position.'),
                  _buildText(
                      'Unlike Wordle — which tells you exactly which letters are correct — this game only tells you the count. You have to figure out which ones!'),
                  const SizedBox(height: 32),
                  _buildSectionTitle('EXAMPLE:'),
                  const SizedBox(height: 12),
                  _buildExampleRow(),
                  const SizedBox(height: 16),
                  _buildText(
                      '"GLARE" contains 2 letters of the secret word, but in another position. 3 letters are not in the secret word.'),
                  const SizedBox(height: 32),
                  _buildSectionTitle('The on-screen keyboard has special keys:'),
                  _buildKeyboardRule(
                      'Spacebar', 'inserts an underscore (_) placeholder. Use it to skip a letter while you search for your next guess (e.g. P _ N _ S).'),
                  _buildKeyboardRule('Clear', 'resets all color markings on the board.'),
                  _buildKeyboardRule('Scratchpad', 'Tap on the letters of your previous guesses to cycle their background colors (red, yellow, green, none) to help you deduce the secret word!'),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 16,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildKeyboardRule(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 16,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: '$title — ',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextSpan(text: description),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleRow() {
    return Wrap(
      spacing: 4,
      runSpacing: 8,
      children: [
        _buildLetterTile('G'),
        _buildLetterTile('L'),
        _buildLetterTile('A'),
        _buildLetterTile('R'),
        _buildLetterTile('E'),
        const SizedBox(width: 4),
        _buildScoreTile('0', kTileGreen),
        _buildScoreTile('2', kTileYellow),
        _buildScoreTile('3', kTileRed),
      ],
    );
  }

  Widget _buildLetterTile(String letter) {
    return Container(
      width: 44,
      height: 44,
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: kTileEmpty,
        borderRadius: BorderRadius.circular(kTileBorderRadius),
        border: Border.all(color: kKbBorder, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildScoreTile(String number, Color color) {
    return Container(
      width: 32,
      height: 44,
      margin: const EdgeInsets.only(left: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(kTileBorderRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        number,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
