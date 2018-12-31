import 'package:flutter/material.dart';
import 'package:screengrabtext/screen_shot.dart';
import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/notification_provider.dart';

class DetectionButton extends StatelessWidget {
  final ScreenShot screenshot = new ScreenShot();
  final NotificationProvider notification = new NotificationProvider();

  _startScreenShot() {
    screenshot.startScreenShot();
  }

  _onScreenShot(BuildContext context, String imagePath) {
    ScreenText screenText = new ScreenText();
    screenText.imagepath = imagePath;
    notification.show(context, screenText);
  }

  @override
  Widget build(BuildContext context) {
    screenshot.screenShotHandler(context, _onScreenShot);
    return new Container(
        width: 60.0,
        height: 60.0,
        child: new FloatingActionButton(
          backgroundColor: Colors.blue,
          tooltip: 'Detect text',
          onPressed: () => _startScreenShot(),
          shape: new CircleBorder(),
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 30,
          ),
        ));
  }
}
