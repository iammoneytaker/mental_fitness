import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String COINS_KEY = 'coins';
  static const String HIGH_SCORE_KEY_PREFIX = 'high_score_';
  static const String DAILY_GAMES_PLAYED_KEY = 'daily_games_played';
  static const String LAST_PLAYED_DATE_KEY = 'last_played_date';

  Future<void> saveCoins(int coins) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(COINS_KEY, coins);
  }

  Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(COINS_KEY) ?? 0;
  }

  Future<void> saveHighScore(String gameType, int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$HIGH_SCORE_KEY_PREFIX$gameType', score);
  }

  Future<int> getHighScore(String gameType) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$HIGH_SCORE_KEY_PREFIX$gameType') ?? 0;
  }

  Future<int> getDailyGamesPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(DAILY_GAMES_PLAYED_KEY) ?? 0;
  }

  Future<void> setDailyGamesPlayed(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(DAILY_GAMES_PLAYED_KEY, count);
  }

  Future<DateTime?> getLastPlayedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final milliseconds = prefs.getInt(LAST_PLAYED_DATE_KEY);
    return milliseconds != null
        ? DateTime.fromMillisecondsSinceEpoch(milliseconds)
        : null;
  }

  Future<void> setLastPlayedDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(LAST_PLAYED_DATE_KEY, date.millisecondsSinceEpoch);
  }
}
