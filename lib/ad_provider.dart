import 'package:firebase_admob/firebase_admob.dart';

class AdProvider {
  InterstitialAd _myInterstitial;
  BannerAd _myBanner;
  //BannerUnitId=ca-app-pub-3841833216293587/8786143162

  MobileAdTargetingInfo initialize(){
    
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['screenshot', 'tech','apps','social','instagram','image','text','scan'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[], // Android emulators are considered test devices
    );
    return targetingInfo;
  }

  loadInterstitial(targetingInfo){
    _myInterstitial = InterstitialAd(
      //adUnitId: InterstitialAd.testAdUnitId,
      adUnitId: 'ca-app-pub-3841833216293587/3942435048',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
    _myInterstitial.load();
  }

  loadBanner(targetingInfo){
    _myBanner = BannerAd(
      //adUnitId: 'ca-app-pub-3841833216293587/8786143162',
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }

  showIntertitial(){
    _myInterstitial.show(    
      anchorType: AnchorType.bottom,
      anchorOffset: 0.0,
    );
  }
  
  showBanner(){
    _myBanner.show(
      anchorOffset: 60.0,
      anchorType: AnchorType.bottom,
    );
  }
}