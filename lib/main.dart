import 'package:flutter/material.dart';
import 'package:screengrabtext/home_drawer.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-3841833216293587~3809148656');
    loadAd();
    return new MaterialApp(
      title: 'ScreenGrab',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeDrawer(),
    );
  }

  loadAd() {
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[], // Android emulators are considered test devices
    );

    InterstitialAd myInterstitial = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
    
    myInterstitial.load();
  }
}
