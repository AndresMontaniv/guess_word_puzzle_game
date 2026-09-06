import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'constants.dart';
import 'screens/welcome_screen.dart';
import 'screens/game_screen.dart';
import 'screens/how_to_play_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure macOS window size (skip on web).
  if (!kIsWeb) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(kWindowWidth, kWindowHeight),
      minimumSize: Size(kWindowMinWidth, kWindowMinHeight),
      center: true,
      title: 'Guess The Word',
      backgroundColor: Color(0xFF121213),
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const GuessWordApp());
}

class GuessWordApp extends StatelessWidget {
  const GuessWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess Word Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBrandDark,
        colorScheme: ColorScheme.dark(
          surface: kBrandDark,
          primary: kTileGreen,
        ),
        fontFamily: 'system-ui',
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const WelcomeScreen(),
        '/game': (_) => const GameScreen(),
        '/how_to_play': (_) => const HowToPlayScreen(),
      },
    );
  }
}
