import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/controllers_instatnceses.dart';

final storage = GetStorage();
final Map<String, dynamic> bugs = <String, dynamic>{};

class StorageHelper {
  static void markedAsWelcomed() {
    storage.write(welcomedStorageKey, true);
  }

  static void markAsDarkModeEnable({bool val = false}) {
    storage.write(darkModeStorageKey, val);
  }

  static bool isWelcomed() {
    return storage.read<bool>(welcomedStorageKey) ?? false;
  }

  static bool isDarkModeSaved() {
    return storage.read<bool>(darkModeStorageKey) ?? false;
  }

  static ThemeMode getThemeMode() {
    final isEnabled = isDarkModeSaved();
    if (!isWelcomed()) {
      return ThemeMode.system;
    } else {
      if (isEnabled) {
        return ThemeMode.dark;
      } else {
        return ThemeMode.light;
      }
    }
  }

  static bool isNotificationEnabled() {
    return storage.read<bool>(notificationEnabledKey) ?? true;
  }

  static void setNotificationState({bool val = true}) {
    storage.write(notificationEnabledKey, val);
  }

  static Map<String, dynamic> getBugLog() {
    return storage.read(bugLogKey) ?? <String, dynamic>{};
  }

  static void bugLog(Object e) {
    bugs[DateTime.now().toString()]=e.toString();
    storage.write("key", bugs);
  }
}
