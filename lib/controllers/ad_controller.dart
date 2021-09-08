import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:facebook_audience_network/ad/ad_rewarded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';
import 'package:whatsapp_gadgets/controllers/app_controller.dart';
import 'package:whatsapp_gadgets/models/accessible_wa_type_model.dart';

class AdController extends GetxController {
  RxList<AccessibleWATypeModel> accessibleWATypes =
      List<AccessibleWATypeModel>.empty(growable: true).obs;
  RxBool isInterstitialLoaded = false.obs;
  RxBool isInterstitialVideoWatched = false.obs;
  RxBool isTypeChangeDialogLoading = false.obs;

  Future<void> addAccessibleWaType() async {
    print("TYPE ADDING.................................!");
    accessibleWATypes.add(
      AccessibleWATypeModel(
        whatsAppType: Get.find<AppController>().selectedWhatsAppType,
        updatedAt: DateTime.now().toString(),
      ),
    );
    isTypeChangeDialogLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isTypeChangeDialogLoading.value = false;
    if (Get.isDialogOpen!) {
      Get.back();
    }
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
          print("Native Ad: $result --> $value");
        },
      );

  void showInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd();
  }

  Future<void> _loadInterstitialAd() async {
    await FacebookInterstitialAd.loadInterstitialAd(
      placementId: "1868610943311642_1868969399942463",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          isInterstitialLoaded.value = true;
        }
        if (result == InterstitialAdResult.DISMISSED) {
          print("Video completed");
          isInterstitialVideoWatched.value = true;
          FacebookInterstitialAd.destroyInterstitialAd();
        }
      },
    );
  }

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
          print("Native Ad: $result --> $value");
        },
      );

  @override
  void onInit() {
    super.onInit();
    _loadInterstitialAd();
    accessibleWATypes
        .add(AccessibleWATypeModel(whatsAppType: WhatsAppType.normal));
    accessibleWATypes
        .add(AccessibleWATypeModel(whatsAppType: WhatsAppType.saved));
    accessibleWATypes.add(AccessibleWATypeModel(whatsAppType: WhatsAppType.gb));
    accessibleWATypes
        .add(AccessibleWATypeModel(whatsAppType: WhatsAppType.dual));

    // Remove Subscriptions after week
    Future.delayed(const Duration(seconds: 15), () {
      for (AccessibleWATypeModel waTypeModel in accessibleWATypes) {
        String? updatedAt = waTypeModel.updatedAt;
        if (updatedAt != null) {
          DateTime updatedAtDate = DateTime.parse(waTypeModel.updatedAt!)
              .add(const Duration(days: 7));
          if (updatedAtDate
              .toUtc()
              .toLocal()
              .isBefore(DateTime.now().toUtc().toLocal())) {
            accessibleWATypes.remove(waTypeModel);
          }
        }
      }
    });
  }
}
