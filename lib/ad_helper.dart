import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return const bool.fromEnvironment('dart.vm.product')
          ? 'ca-app-pub-6451550267398782/1378966864' // 실제 광고 ID로 교체하세요
          : 'ca-app-pub-3940256099942544/6300978111'; // 테스트 광고 ID
    } else if (Platform.isIOS) {
      return const bool.fromEnvironment('dart.vm.product')
          ? 'ca-app-pub-6451550267398782/2460114243' // 실제 광고 ID로 교체하세요
          : 'ca-app-pub-3940256099942544/2934735716'; // 테스트 광고 ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
