import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage_access_framework/storage_access_framework.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';
import 'package:whatsapp_gadgets/helpers/snack_helper.dart';
import 'package:whatsapp_gadgets/helpers/storage_helper.dart';
import 'package:whatsapp_gadgets/helpers/utils.dart';

class AdController extends GetxController {
  final List<WhatsAppType> tempList = List<WhatsAppType>.empty(growable: true);
  RxList<WhatsAppType> accessibleWATypes = <WhatsAppType>[].obs;
  final RxBool isInterstitialLoaded = false.obs;
  final RxBool isInterstitialVideoWatched = false.obs;
  final RxBool isTypeChangeDialogLoading = false.obs;
  final RxBool isPremiumUnlocked = false.obs;

  Future<void> unlockPremium(bool forUnlockMessages) async {
    isTypeChangeDialogLoading.value = true;
    isPremiumUnlocked.value = true;
    StorageHelper.saveFeatureState(true);
    _loadFeatures();
    await Future.delayed(const Duration(seconds: 3));
    isTypeChangeDialogLoading.value = false;
    if (Get.isDialogOpen!) {
      Get.back();
    }
    if (forUnlockMessages) {
      Get.toNamed('/messages');
    }
    SnackHelper.unlockedByAd();
  }

  FacebookNativeAd typeChangeDialogNativeAd() => FacebookNativeAd(
        placementId: "1868610943311642_1868983939941009",
        adType: NativeAdType.NATIVE_AD,
        width: double.infinity,
        height: Get.height / 2,
        backgroundColor: Colors.blue,
        titleColor: Colors.white,
        descriptionColor: Colors.white,
        buttonColor: Colors.deepPurple,
        buttonTitleColor: Colors.white,
        buttonBorderColor: Colors.white,
        keepAlive: true,
        //set true if you do not want adview to refresh on widget rebuild
        keepExpandedWhileLoading: false,
        // set false if you want to collapse the native ad view when the ad is loading
        expandAnimationDuraion: 300,
        //in milliseconds. Expands the adview with animation when ad is loaded

        listener: (result, value) {
          // print("Native Ad: $result --> $value");
        },
      );

  FacebookNativeAd mainTopNativeBannerAd(BuildContext context) =>
      FacebookNativeAd(
        placementId: "1868610943311642_1868611856644884",
        adType: NativeAdType.NATIVE_BANNER_AD,
        bannerAdSize: NativeBannerAdSize.HEIGHT_50,
        width: double.infinity,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        titleColor: context.theme.accentColor,
        descriptionColor: context.theme.accentColor,
        buttonColor: Colors.green,
        buttonTitleColor: Colors.white,
        buttonBorderColor: Colors.white,
        listener: (result, value) {
          // print("Native Ad: $result --> $value");
        },
      );

  void _loadFeatures() {
    Map<String, dynamic> result = StorageHelper.getFeatures();
    bool unlocked = result['unlocked'] as bool;
    String date = result['updatedAt'].toString();
    if (date.contains('null')) {
      _addDefaultFeatures();
    } else {
      if (unlocked) {
        _addPremiumFeatures(date);
      } else {
        _addDefaultFeatures();
      }
    }
  }

  void _addPremiumFeatures(String date) {
    DateTime dateTime = DateTime.parse(date).add(durationOneWeek);
    if (dateTime.isAfter(DateTime.now())) {
      _addDefaultFeatures();
      for (WhatsAppType type in allWATypes) {
        if (!accessibleWATypes.contains(type)) {
          accessibleWATypes.add(type);
        }
      }
      // print('FEATURES ${accessibleWATypes.length}');
      isPremiumUnlocked.value = true;
      StorageHelper.saveFeatureState(true);
    } else {
      _addDefaultFeatures();
      StorageHelper.saveFeatureState(false);
    }
    accessibleWATypes.toSet().toList();
  }

  Future<void> _addDefaultFeatures() async {
    isPremiumUnlocked.value = false;
    final int? _buildVersion = await StorageAccessFramework.platformVersion;
    if (_buildVersion != null) {
      List<WhatsAppType> list = List<WhatsAppType>.empty(growable: true);
      await Utils.checkInstalledWhatsApps(_buildVersion);
      if (tempList.isNotEmpty) {
        if (tempList.length > 2) {
          list.addAll(tempList.sublist(0, 2).toList());
        } else {
          list.addAll(tempList);
        }
        accessibleWATypes.addAll(list);
      } else {
        accessibleWATypes.add(WhatsAppType.normal);
      }
    }
    accessibleWATypes.add(WhatsAppType.saved);
    accessibleWATypes.toSet().toList();
  }

  @override
  void onInit() async {
    super.onInit();
    _loadFeatures();
  }
}

final allWATypes = [
  WhatsAppType.normal,
  WhatsAppType.dual,
  WhatsAppType.w4b,
  WhatsAppType.gb,
  WhatsAppType.saved,
];
