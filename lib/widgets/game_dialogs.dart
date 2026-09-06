import 'package:flutter/material.dart';

import '../constants.dart';

/// Shows the win dialog.
void showWinDialog(BuildContext context, int guessCount, VoidCallback onPlayAgain) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: kBoardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: kTileGreen.withValues(alpha: 0.3)),
      ),
      title: const Text(
        'You won! 🎉',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
      ),
      content: Text(
        'You found the word in $guessCount ${guessCount == 1 ? 'guess' : 'guesses'}!',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: 160,
          height: 44,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onPlayAgain();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kTileGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            child: const Text('Play Again', textAlign: TextAlign.center),
          ),
        ),
      ],
    ),
  );
}

/// Shows the loss dialog, revealing the secret word.
void showLossDialog(BuildContext context, String secretWord, VoidCallback onPlayAgain) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: kBoardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: kTileRed.withValues(alpha: 0.3)),
      ),
      title: const Text(
        'Oh no!',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
      ),
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
          children: [
            const TextSpan(text: 'The secret word was\n'),
            TextSpan(
              text: secretWord,
              style: const TextStyle(color: kTileYellow, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 3),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: 180,
          height: 44,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onPlayAgain();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kTileGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            child: const Text('Start New Game', textAlign: TextAlign.center),
          ),
        ),
      ],
    ),
  );
}
