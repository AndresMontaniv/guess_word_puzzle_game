# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0+1] - 2026-09-06

### Initial Release (macOS TestFlight)

#### Added
- **Core Game Mechanics**:
  - Offline logic deduction word puzzle challenging players to guess a hidden 5-letter isogram word within 8 attempts.
  - Dual feedback scoring system:
    - **Exact Match (Green)**: Letter exists and is placed in the exact slot.
    - **Contained Match (Yellow)**: Letter exists in the secret word but belongs in a different position.
    - **Absent (Red / Gray)**: Letter does not exist in the target word.
  - Curated, clean vocabulary containing over 1,500 5-letter secret words and a comprehensive dictionary of over 8,000 accepted guesses.
  - Staggered 3D tile-flip animations providing rewarding reveal transitions upon guess submission.
  - Error feedback with shake animation for invalid dictionary submissions or incomplete entries.

- **User Interface & Experience**:
  - Minimalist dark-mode theme inspired by modern word games (`#121213` palette).
  - Welcome Screen with quick start and access to gameplay guides.
  - Dedicated "How to Play" screen with illustrated examples explaining the deduction scoring rules.
  - Interactive on-screen QWERTY keyboard with dynamic color tracking reflecting discovered letters.
  - Full hardware keyboard support for physical typing, Enter submission, and Backspace deletion on macOS.
  - Non-intrusive in-grid Game Over panel celebrating victories or revealing the target secret word.

- **macOS Integration & TestFlight Readiness**:
  - macOS App Sandbox enabled (`com.apple.security.app-sandbox = true`) for Mac App Store and TestFlight compatibility.
  - Export compliance pre-configured (`ITSAppUsesNonExemptEncryption = false`) to bypass App Store Connect compliance prompts.
  - Configured macOS App Category (`public.app-category.word-games`).
  - Production-ready macOS asset catalog with full icon density resolutions (16x16 through 1024x1024 Retina).
  - Desktop window configuration with custom constraints (800x700 standard, 600x500 minimum) via `window_manager`.
  - Universal binary build supporting both Apple Silicon (`arm64`) and Intel (`x86_64`) Macs.
