import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/controllers_instance.dart';
import 'package:whatsapp_gadgets/helpers/function_helper.dart';
import 'package:whatsapp_gadgets/helpers/snack_helper.dart';
import 'package:storage_access_framework/storage_access_framework.dart';
import 'package:video_compress/video_compress.dart';

class VideoController extends GetxController {
  final RxList<Uint8List> _videoList =
      List<Uint8List>.empty(growable: true).obs;
  final RxList<Uint8List> _thumbnails =
      List<Uint8List>.empty(growable: true).obs;
  final _selectedVideoList = List<int>.empty(growable: true).obs;
  final RxBool _loading = true.obs;

  bool get isLoading => _loading.value;

  List<Uint8List> get getVideos => _videoList;

  List<Uint8List> get getThumbnails => _thumbnails;

  List<int> get selectedVideoList => _selectedVideoList;

  Future<void> saveVideo({int? index}) async {
    try {
      final _selected = List<int>.from(_selectedVideoList);
      _selectedVideoList.clear();
      late bool isSaved;
      if (index == null) {
        isSaved = await FunctionHelper.saveImage(
          selectedList: _selected,
          list: _videoList,
          type: 'video/mp4',
        );
      } else {
        _selected.add(index);
        isSaved = await FunctionHelper.saveImage(
          selectedList: _selected,
          list: _videoList,
          type: 'video/mp4',
        );
      }

      if (isSaved) {
        SnackHelper.savedSnack();
      }
      _selected.clear();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> shareVideo({String? package, int? selectedIndex}) async {
    try {
      if (selectedIndex != null) {
        _selectedVideoList.clear();
        _selectedVideoList.add(selectedIndex);
      }
      final dir = await getTemporaryDirectory();
      List<String> paths = List<String>.empty(growable: true);
      late String imgPath;
      for (int i = 0; i < _selectedVideoList.length; i++) {
        imgPath = '${dir.path}/$tempShareName$i.mp4';
        final newFile = File(imgPath);
        await newFile.writeAsBytes(_videoList[_selectedVideoList[i]]);
        paths.add(imgPath);
      }
      if (package == null) {
        await Share.shareFiles(
          paths,
        );
      } else {
        await Share.shareFiles(
          paths,
          packageName: package,
        );
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> deleteVideos() async {
    try {
      final _selected = List<int>.from(_selectedVideoList);
      _selectedVideoList.clear();
      for (final i in _selected) {
        final list = Directory(savedDirectory).listSync();
        File(list[i].path).deleteSync();
        _videoList.removeAt(i);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> handleRefresh() async {
    return await controller.handleRefresh();
  }

  void selectVideo(int index) {
    if (selectedVideoList.contains(index)) {
      selectedVideoList.remove(index);
    } else {
      selectedVideoList.add(index);
    }
  }

  void selectAllVideos() {
    if (_selectedVideoList.length == _videoList.length) {
      _selectedVideoList.clear();
    } else {
      _selectedVideoList.clear();
      for (int i = 0; i < _videoList.length; i++) {
        _selectedVideoList.add(i);
      }
    }
  }

  Future<void> generateThumbnails() async {
    try {
      final dir = await getTemporaryDirectory();
      for (int i = 0; i < _videoList.length; i++) {
        final newFile = File('${dir.path}/$tempThumbName.mp4');
        await newFile.writeAsBytes(_videoList[i]);
        Uint8List? bytes = await VideoCompress.getByteThumbnail(
          newFile.path,
        );
        if (bytes != null) {
          _thumbnails.add(bytes);
        } else {
          //TODO: DO SOMETHING FOR THIS MAN
          _thumbnails.add(Uint8List.fromList([]));
        }
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Future<void> loadVideos({
    String api30Path = whatsAppApi30,
    String path1 = whatsApp,
    String path2 = whatsApp2,
    bool fromDirectory = false,
  }) async {
    _loading.value = true;
    _videoList.clear();

    final List<Uint8List> list = List<Uint8List>.empty(growable: true);
    try {
      if (await controller.isNewVersion() && !fromDirectory) {
        list.addAll(
          await StorageAccessFramework.getFiles(
            uri: api30Path,
            fileExtensions: [
              '.mp4',
              // '.gif',
            ],
          ),
        );
      } else {
        final Directory w1 = Directory.fromUri(Uri.parse(path1));
        final Directory w2 = Directory.fromUri(Uri.parse(path2));

        if (w1.existsSync()) {
          if (w1.listSync().isNotEmpty) {
            w1.listSync().forEach((element) {
              if (element.path.endsWith('.mp4')) {
                list.add(File.fromUri(element.uri).readAsBytesSync());
              }
            });
          }
        } else {
          if (w2.existsSync()) {
            if (w2.listSync().isNotEmpty) {
              w2.listSync().forEach((element) {
                if (element.path.endsWith('.mp4')) {
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
        _videoList.addAll(list);
        await generateThumbnails();
      }
      _loading.value = false;
    }
  }


}
