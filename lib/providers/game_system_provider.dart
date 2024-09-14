import 'package:flutter/foundation.dart';
import 'package:mental_fitness/services/storage_service.dart';

class GameSystemProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  int _coins = 0;
  int _dailyGamesPlayed = 0;
  static const int MAX_DAILY_GAMES = 3;
  DateTime? _lastPlayedDate;

  GameSystemProvider() {
    _loadData();
  }

  int get coins => _coins;
  int get dailyGamesPlayed => _dailyGamesPlayed;
  bool get canPlayMore => _dailyGamesPlayed < MAX_DAILY_GAMES;

  Future<void> _loadData() async {
    _coins = await _storageService.getCoins();
    _dailyGamesPlayed = await _storageService.getDailyGamesPlayed();
    _lastPlayedDate = await _storageService.getLastPlayedDate();
    _resetDailyGamesIfNeeded();
    notifyListeners();
  }

  void _resetDailyGamesIfNeeded() {
    final now = DateTime.now();
    if (_lastPlayedDate == null || !isSameDay(now, _lastPlayedDate!)) {
      _dailyGamesPlayed = 0;
      _storageService.setDailyGamesPlayed(0);
      _storageService.setLastPlayedDate(now);
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> addCoins(int amount) async {
    _coins += amount;
    await _storageService.saveCoins(_coins);
    notifyListeners();
  }

  Future<bool> useCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      await _storageService.saveCoins(_coins);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> useHint() async {
    const int hintCost = 50;
    return useCoins(hintCost);
  }

  Future<bool> playGame() async {
    if (canPlayMore) {
      _dailyGamesPlayed++;
      await _storageService.setDailyGamesPlayed(_dailyGamesPlayed);
      await _storageService.setLastPlayedDate(DateTime.now());
      notifyListeners();
      return true;
    }
    return false;
  }
}
