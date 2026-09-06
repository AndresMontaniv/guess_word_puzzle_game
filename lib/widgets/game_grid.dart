import 'package:flutter/material.dart';
import '../constants.dart';
import '../game_state.dart';
import 'shake_animation.dart';

/// Renders the 8-row game grid with 5 letter tiles + 3 score tiles per row.
/// Uses a fixed 8-column grid layout that scales to fit the available space.
class GameGrid extends StatelessWidget {
  final GameState gameState;
  final List<GlobalKey<ShakeWidgetState>> shakeKeys;
  final void Function(int rowIndex, int cellIndex) onTileTap;

  const GameGrid({
    super.key,
    required this.gameState,
    required this.shakeKeys,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate tile size based on available space.
        // Grid is 8 columns wide (5 letter + 3 score), 8 rows tall.
        final totalGapH = kTileGap * 8; // gaps between columns + padding
        final availableWidth = constraints.maxWidth - totalGapH;
        final tileSize = availableWidth / 8;

        // Clamp tile size so it doesn't overflow vertically either.
        final totalGapV = kTileGap * 9; // gaps between rows + padding
        final maxTileSizeV = (constraints.maxHeight - totalGapV) / 8;
        final effectiveTileSize = tileSize.clamp(0.0, maxTileSizeV);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(kMaxRows, (rowIndex) {
            final row = gameState.rows[rowIndex];
            final isActive = rowIndex == gameState.activeRowIndex &&
                gameState.status == GameStatus.playing;

            Widget rowWidget =
                _buildRow(row, rowIndex, isActive, effectiveTileSize);

            if (isActive) {
              return ShakeWidget(
                key: shakeKeys[rowIndex],
                child: rowWidget,
              );
            }
            return rowWidget;
          }),
        );
      },
    );
  }

  Widget _buildRow(
      RowData row, int rowIndex, bool isActive, double tileSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kTileGap / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 5 letter tiles
          ...List.generate(5, (cellIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: kTileGap / 2),
              child: _buildLetterTile(
                  row, rowIndex, cellIndex, isActive, tileSize),
            );
          }),
          SizedBox(width: kTileGap * 1.5),
          // 3 score tiles (Green, Yellow, Red)
          _buildScoreTile(row, kTileGreen, row.score?.green, tileSize),
          const SizedBox(width: kTileGap / 2),
          _buildScoreTile(row, kTileYellow, row.score?.yellow, tileSize),
          const SizedBox(width: kTileGap / 2),
          _buildScoreTile(row, kTileRed, row.score?.red, tileSize),
        ],
      ),
    );
  }

  Widget _buildLetterTile(
      RowData row, int rowIndex, int cellIndex, bool isActive, double size) {
    final letter = row.letters[cellIndex];
    final hasLetter = letter.isNotEmpty;

    Color bgColor;
    if (row.isSettled) {
      if (hasLetter && gameState.disabledLetters.contains(letter)) {
        bgColor = kTileRed;
      } else {
        bgColor = _scratchColorToColor(row.scratchColors[cellIndex]);
      }
    } else {
      bgColor = kTileEmpty;
    }

    final isCursor = isActive && cellIndex == gameState.activeCellIndex;
    if (isCursor && !hasLetter) {
      bgColor = kKeyActive;
    }

    final fontSize = (size * 0.4).clamp(12.0, 22.0);

    return GestureDetector(
      onTap: row.isSettled ? () => onTileTap(rowIndex, cellIndex) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(kTileBorderRadius),
          border: isCursor
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.4), width: 2)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          hasLetter ? letter : '',
          style: TextStyle(
            color: letter == '_'
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreTile(
      RowData row, Color bgColor, int? value, double size) {
    final fontSize = (size * 0.38).clamp(11.0, 18.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(kTileBorderRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        value != null ? '$value' : '',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Color _scratchColorToColor(TileScratchColor sc) {
    switch (sc) {
      case TileScratchColor.red:
        return kTileRed;
      case TileScratchColor.yellow:
        return kTileYellow;
      case TileScratchColor.green:
        return kTileGreen;
      case TileScratchColor.none:
        return kTileEmpty;
    }
  }
}
