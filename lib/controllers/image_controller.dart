import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/controllers_instatnceses.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';
import 'package:whatsapp_gadgets/helpers/function_helper.dart';
import 'package:whatsapp_gadgets/helpers/snack_helper.dart';
import 'package:storage_access_framework/storage_access_framework.dart';

class ImageController extends GetxController {
  static final AppController _appController = Get.find<AppController>();
  final GlobalKey<LiquidPullToRefreshState> refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  final RxList<Uint8List> _imageList =
      List<Uint8List>.empty(growable: true).obs;
  final _selectedImageList = List<int>.empty(growable: true).obs;
  final RxBool _loading = true.obs;

  bool get isLoading => _loading.value;

  //Image List
  List<Uint8List> get getImages => _imageList;

  List<int> get selectedImageList => _selectedImageList;

  int get imageCount => _imageList.length;

  void selectAllImages() {
    if (_selectedImageList.length == _imageList.length) {
      _selectedImageList.clear();
    } else {
      _selectedImageList.clear();
      for (int i = 0; i < getImages.length; i++) {
        _selectedImageList.add(i);
      }
    }
  }

  Future<void> shareImage({String? package}) async {
    await controller.clearCache();
    final dir = await getTemporaryDirectory();
    final List<String> paths = List<String>.empty(growable: true);
    // late String imgPath;
    for (int i = 0; i < _selectedImageList.length; i++) {
      final imgPath = '${dir.path}/$tempShareName$i.jpg';
      final newFile = File(imgPath);
      await newFile.writeAsBytes(_imageList[_selectedImageList[i]]);
      print(imgPath);
      print(_selectedImageList.first);
      paths.add(imgPath);
    }
    if (package == null) {
      await Share.shareFiles(
        paths,
      );
    } else {
      try {
        await Share.shareFiles(
          paths,
          packageName: package,
        );
      } catch (e, stack) {
        FirebaseCrashlytics.instance.log(e.toString());
        FirebaseCrashlytics.instance.recordError(e, stack);
      }
    }
  }

  Future<void> saveImage() async {
    try {
      final _selected = List<int>.from(_selectedImageList);
      _selectedImageList.clear();
      if (await FunctionHelper.saveImage(
        selectedList: _selected,
        list: _imageList,
        type: 'image/jpeg',
      )) {
        SnackHelper.savedSnack();
      }
      _selected.clear();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> deleteImages() async {
    try {
      final _selected = List<int>.from(_selectedImageList);
      _selectedImageList.clear();
      for (final i in _selected) {
        final list = Directory(savedDirectory).listSync();
        File(list[i].path).deleteSync();
        _imageList.removeAt(i);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> handleRefresh() async {
    final Completer<void> completer = Completer<void>();
    await controller.handleRefresh();
    return Future<Null>(() {});
  }

  void selectImage(int index) {
    if (_selectedImageList.contains(index)) {
      _selectedImageList.remove(index);
    } else {
      _selectedImageList.add(index);
    }
  }

  void setSelectedSingleImage(int index) {
    _selectedImageList.clear();
    _selectedImageList.add(index);
  }


  int _repeater = 0;
  Future<void> loadImages({
    String api30Path = whatsAppApi30,
    String path1 = whatsApp,
    String path2 = whatsApp2,
    bool fromDirectory = false,
  }) async {
    print('images loading==============================>');
    _loading.value = true;
    update();
    _imageList.clear();
    _selectedImageList.clear();

    final List<Uint8List> list = List<Uint8List>.empty(growable: true);
    try {
      if (await _appController.isNewVersion() && !fromDirectory) {
        list.addAll(
          await StorageAccessFramework.getFiles(
            uri: api30Path,
            fileExtensions: [
              '.jpg',
              '.jpeg',
              '.png',
              // '.mp4',
            ],
          ),
        );
      } else {
        final Directory w1 = Directory.fromUri(Uri.parse(path1));
        final Directory w2 = Directory.fromUri(Uri.parse(path2));

        if (w1.existsSync()) {
          if (w1.listSync().isNotEmpty) {
            w1.listSync().forEach((element) {
              if (element.path.endsWith('.jpg') ||
                  element.path.endsWith('.jpeg') ||
                  element.path.endsWith('.png') ||
                  element.path.endsWith('.gif')) {
                list.add(File.fromUri(element.uri).readAsBytesSync());
              }
            });
          }
        } else {
          if (w2.existsSync()) {
            if (w2.listSync().isNotEmpty) {
              w2.listSync().forEach((element) {
                if (element.path.endsWith('.jpg') ||
                    element.path.endsWith('.jpeg') ||
                    element.path.endsWith('.png') ||
                    element.path.endsWith('.gif')) {
                  list.add(File.fromUri(element.uri).readAsBytesSync());
                }
              });
            }
          }
        }
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    } finally {
      if (list.isNotEmpty) {
        _imageList.addAll(list);
      }
      _loading.value = false;
      update();
      if(_imageList.isEmpty){
        if(_repeater<2){
          controller.handleRefresh();
          _repeater++;
        }
      }
      print('images loading==============================> ${_imageList.length}');
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadImages();
  }
}
