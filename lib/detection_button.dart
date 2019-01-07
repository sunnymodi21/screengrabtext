import 'package:flutter/material.dart';
import 'package:screengrabtext/screen_shot.dart';
import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/notification_provider.dart';
import 'package:screengrabtext/image_pick_button.dart';

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
    return new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new ImagePickerButton(),
        new Container(
          width: 50.0,
          height: 50.0,
          margin: new EdgeInsets.only(bottom: 10.0),
          child: new FloatingActionButton(
            heroTag: "detectionbutton",
            backgroundColor: Colors.blue,
            tooltip: 'Detect text',
            onPressed: () => _startScreenShot(),
            shape: new CircleBorder(),
            child: Icon(
              Icons.crop_free,
              color: Colors.white,
              size: 27,
            ),
          )),
      ]
    );
  }
}
