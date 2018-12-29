import 'package:flutter/services.dart';

class ScreenShot {
  static const platform =
      const MethodChannel('com.inlogica.screengrabtext/takeshot');

  startScreenShot() {
    platform.invokeMethod('startProjection');
  }

  screenShotHandler(context, _onScreenShot){
      platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onScreenShot') {
        print('location, ${call.arguments}');
        String imagePath = call.arguments;
        _onScreenShot(context, imagePath);
      }
    });
  }
}
