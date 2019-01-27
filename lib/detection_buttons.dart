import 'package:flutter/material.dart';
import 'package:screengrabtext/screen_shot.dart';
import 'package:screengrabtext/notification_provider.dart';
import 'package:screengrabtext/image_pick_button.dart';
import 'package:screengrabtext/screenshot_button.dart';

class DetectionButton extends StatelessWidget {
  final ScreenShot screenshot = new ScreenShot();
  final NotificationProvider notification = new NotificationProvider();

  _startScreenShot() {
    screenshot.startScreenShot();
  }

  _onScreenShot(BuildContext context, String imagePath) {
    notification.show(context, imagePath);
  }

  @override
  Widget build(BuildContext context) {
    screenshot.screenShotHandler(context, _onScreenShot);
    return new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new ImagePickerButton('camera'),
        new ImagePickerButton('gallery'),
        new ScreenShotButton(_startScreenShot),
      ]
    );
  }
}
