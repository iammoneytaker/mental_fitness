import 'package:flutter/foundation.dart';
import 'package:mental_fitness/services/storage_service.dart';

class GameProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  int _coins = 0;

  GameProvider() {
    _loadCoins();
  }

  int get coins => _coins;

  Future<void> _loadCoins() async {
    _coins = await _storageService.getCoins();
    notifyListeners();
  }

  Future<void> addCoins(int amount) async {
    _coins += amount;
    await _storageService.saveCoins(_coins);
    notifyListeners();
  }

  Future<void> useCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      await _storageService.saveCoins(_coins);
      notifyListeners();
    }
  }

  Future<void> saveHighScore(String gameType, int score) async {
    int currentHighScore = await _storageService.getHighScore(gameType);
    if (score > currentHighScore) {
      await _storageService.saveHighScore(gameType, score);
    }
  }

  Future<int> getHighScore(String gameType) async {
    return await _storageService.getHighScore(gameType);
  }
}
