import 'package:flutter/services.dart';

class PlatformHandleHelper {
  static const _platform = MethodChannel('DEWZ.STATUS.SAVER');
  static const _isAppAvailableCode = 'IS_APP_AVAILABLE';

  static Future<bool> ifAppInstalled(String packageName) async {
    await _platform.invokeMethod(_isAppAvailableCode, packageName);
    return true;
  }
}
