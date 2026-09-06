import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences to manage
/// a 10-item FIFO queue of recently played secret words.
class WordCache {
  static const _key = 'recent_words';
  static const _maxSize = 10;

  /// Returns the list of recently played words.
  static Future<List<String>> getRecentWords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Adds a word to the cache, evicting the oldest if > [_maxSize].
  static Future<void> addWord(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final recent = prefs.getStringList(_key) ?? [];
    recent.add(word);
    if (recent.length > _maxSize) {
      recent.removeAt(0);
    }
    await prefs.setStringList(_key, recent);
  }

  /// Checks if a word was recently played.
  static Future<bool> wasRecentlyPlayed(String word) async {
    final recent = await getRecentWords();
    return recent.contains(word);
  }
}
