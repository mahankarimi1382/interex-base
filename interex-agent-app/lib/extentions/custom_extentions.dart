import 'package:get_storage/get_storage.dart';

import '../backend/services/api_endpoint.dart';
import '../utils/basic_screen_imports.dart';

extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }
}

extension EndPointExtensions on String {
  String addBaseURl() {
    return "${ApiEndpoint.baseUrl}$this?lang=${GetStorage().read('selectedLanguage')}";
  }

  String addBaseURlDefault() {
    return "${ApiEndpoint.baseUrl}$this";
  }

  double parseDouble() {
    return double.parse(this);
  }
}

extension NetworkUrlHostFix on String {
  /// Rewrites loopback hosts coming from the backend (e.g. the seeded
  /// `http://127.0.0.1:8000` APP_URL) to the host the app actually talks to.
  /// On an Android emulator `127.0.0.1` points to the device itself, so image
  /// URLs built from the backend base url fail to load without this fix.
  /// In production the backend returns a real domain, so this is a no-op.
  String fixHost() {
    return replaceAll('127.0.0.1', ApiEndpoint.host).replaceAll(
      'localhost',
      ApiEndpoint.host,
    );
  }
}

extension CardFormatter on String {
  String formatCardNumber() {
    final String inputData = this;
    final StringBuffer buffer = StringBuffer();

    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      final int index = i + 1;

      if (index % 4 == 0 && inputData.length != index) {
        buffer.write(" ");
      }
    }

    return buffer.toString();
  }

  String formatCardExpiration() {
    final String inputData = this;
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      final nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != inputData.length) {
        buffer.write('/');
      }
    }
    return buffer.toString();
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
