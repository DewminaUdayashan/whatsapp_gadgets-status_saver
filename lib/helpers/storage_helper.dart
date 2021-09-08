import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/controllers/ad_controller.dart';
import 'package:whatsapp_gadgets/models/accessible_wa_type_model.dart';

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

  static void saveUnlockedTypes(List<AccessibleWATypeModel> list) {
    final List<Map<String, dynamic>> maps = <Map<String, dynamic>>[];
    for (final value1 in list) {
      maps.add(Map<String, dynamic>.from(value1.toJson()));
    }
    storage.write(saveUnlockedTypesKey, maps);
  }

  static List<AccessibleWATypeModel> getUnlockedTypes() {
    final list = storage.read<List>(saveUnlockedTypesKey) ?? [];

    return list
        .map(
            (e) => AccessibleWATypeModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static void saveMessageFeatureUnlockedStatus(bool status) {
    storage.write(messageFeatureUnlockedState, <String, dynamic>{
      "status": status,
      "updatedAt": DateTime.now().toString(),
    });
  }

  static Map<String, dynamic> isMessageFeatureUnlocked() {
    final Map<String, dynamic> map = Map<String, dynamic>.from(
        storage.read<Map>(messageFeatureUnlockedState) ??
            {"status": false, "updatedAt": "null"});
    return map;
  }
}
