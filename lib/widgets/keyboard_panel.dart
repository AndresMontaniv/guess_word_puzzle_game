import 'package:flutter/material.dart';
import '../constants.dart';

/// On-screen QWERTY keyboard with action buttons (Eraser, Hint, Space, Submit, Backspace).
class KeyboardPanel extends StatelessWidget {
  final Set<String> disabledLetters;
  final void Function(String letter) onLetterTap;
  final VoidCallback onBackspace;
  final VoidCallback onSpace;
  final VoidCallback onSubmit;
  final VoidCallback onErase;
  final bool enabled;

  const KeyboardPanel({
    super.key,
    required this.disabledLetters,
    required this.onLetterTap,
    required this.onBackspace,
    required this.onSpace,
    required this.onSubmit,
    required this.onErase,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kKbPanel.withValues(alpha: 0.95),
        border: Border.all(color: kKbBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Q-P
          _buildLetterRow(kQwertyRows[0]),
          const SizedBox(height: 6),

          // Row 2: A-L (slightly indented)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _buildLetterRow(kQwertyRows[1]),
          ),
          const SizedBox(height: 6),

          // Row 3: Z-M + Backspace
          _buildLetterRowWithBackspace(kQwertyRows[2]),
          const SizedBox(height: 8),

          // Row 4: Action bar (Eraser, Hint, Space, Submit)
          _buildActionBar(),
        ],
      ),
    );
  }

  Widget _buildLetterRow(List<String> letters) {
    return Row(
      children: letters.map((letter) {
        final isDisabled = disabledLetters.contains(letter);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: _KeyButton(
              label: letter,
              onTap: (enabled && !isDisabled) ? () => onLetterTap(letter) : null,
              bgColor: isDisabled ? kKeyDisabled : kKeyBg,
              textColor: isDisabled
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.85),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLetterRowWithBackspace(List<String> letters) {
    return Row(
      children: [
        // Letter keys
        ...letters.map((letter) {
          final isDisabled = disabledLetters.contains(letter);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: _KeyButton(
                label: letter,
                onTap:
                    (enabled && !isDisabled) ? () => onLetterTap(letter) : null,
                bgColor: isDisabled ? kKeyDisabled : kKeyBg,
                textColor: isDisabled
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.85),
              ),
            ),
          );
        }),
        // Backspace button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: _KeyButton(
              icon: Icons.backspace_outlined,
              onTap: enabled ? onBackspace : null,
              bgColor: kKeyDisabled,
              textColor: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        // Eraser button
        SizedBox(
          width: 48,
          child: _KeyButton(
            icon: Icons.auto_fix_high,
            onTap: enabled ? onErase : null,
            bgColor: kKeyBg,
            textColor: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 8),

        // Hint button (disabled placeholder)
        SizedBox(
          width: 44,
          child: _KeyButton(
            icon: Icons.lightbulb_outline,
            onTap: null, // Disabled — out of scope for MVP.
            bgColor: kKeyDisabled,
            textColor: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        const SizedBox(width: 8),

        // Space bar
        Expanded(
          child: _KeyButton(
            label: 'SPACE',
            onTap: enabled ? onSpace : null,
            bgColor: kKeyBg,
            textColor: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(width: 8),

        // Submit / Checkmark button
        SizedBox(
          width: 44,
          child: _KeyButton(
            icon: Icons.check,
            onTap: enabled ? onSubmit : null,
            bgColor: kKeyDisabled,
            textColor: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

/// Individual key button with press animation.
class _KeyButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color bgColor;
  final Color textColor;
  final double fontSize;
  final double letterSpacing;

  const _KeyButton({
    this.label,
    this.icon,
    this.onTap,
    required this.bgColor,
    required this.textColor,
    this.fontSize = 14,
    this.letterSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          height: 44,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: icon != null
              ? Icon(icon, color: textColor, size: 20)
              : Text(
                  label ?? '',
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    letterSpacing: letterSpacing,
                  ),
                ),
        ),
      ),
    );
  }
}
