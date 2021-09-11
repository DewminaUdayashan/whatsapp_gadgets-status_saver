import 'dart:typed_data';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:storage_access_framework/storage_access_framework.dart';
import 'package:whatsapp_gadgets/helpers/snack_helper.dart';

class FunctionHelper {
  static Future<bool> saveImage({
    required List<int> selectedList,
    required List<Uint8List> list,
    required String type,
  }) async {
    final List<Uint8List> send = List<Uint8List>.empty(growable: true);
    late bool isSaved;
    for (final value in selectedList) {
      send.add(list[value]);
    }
    try {
      isSaved = await StorageAccessFramework.saveMedia(
          bytesList: send, mimeType: type);
      selectedList.clear();
      // SnackHelper.savedSnack();
    } catch (e, stack) {
      isSaved = false;
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
      SnackHelper.saveError();
    }
    return isSaved;
  }
}
