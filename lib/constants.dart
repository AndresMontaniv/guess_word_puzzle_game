import 'package:flutter/material.dart';

// ─── Color Palette (extracted from Stitch HTML) ─────────────────────────────

const Color kBrandDark = Color(0xFF121213);
const Color kBoardDark = Color(0xFF1A1A1D);
const Color kTileEmpty = Color(0xFF2B2C30);
const Color kTileGreen = Color(0xFF4EA85B);
const Color kTileYellow = Color(0xFFD6B34E);
const Color kTileRed = Color(0xFFDC4F53);
const Color kKeyBg = Color(0xFF34363D);
const Color kKeyActive = Color(0xFF43464F);
const Color kKeyDisabled = Color(0xFF1C1D22);
const Color kKbPanel = Color(0xFF191A1E);
const Color kKbBorder = Color(0xFF27282E);

// ─── Grid Dimensions ────────────────────────────────────────────────────────

const int kMaxRows = 8;
const int kWordLength = 5;

// ─── Tile Styling ───────────────────────────────────────────────────────────

const double kTileBorderRadius = 9.0;
const double kTileGap = 5.0;
const double kMaxContentWidth = 650.0;

// ─── Window Defaults (macOS) ────────────────────────────────────────────────

const double kWindowWidth = 800.0;
const double kWindowHeight = 700.0;
const double kWindowMinWidth = 600.0;
const double kWindowMinHeight = 500.0;

// ─── QWERTY Keyboard Layout ────────────────────────────────────────────────

const List<List<String>> kQwertyRows = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
];
