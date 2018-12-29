import 'package:flutter/material.dart';
import 'package:screengrabtext/screen_shot.dart';
import 'package:screengrabtext/detection_screen.dart';
import 'package:screengrabtext/screen_text_provider.dart';

class DetectionButton extends StatelessWidget {
  
  final ScreenShot screenshot = new ScreenShot();
  _startScreenShot(BuildContext context) {
    screenshot.startScreenShot();
  }

  _onScreenShot(BuildContext context, String imagePath) {
    ScreenText screenText = new ScreenText();
    screenText.imagepath = imagePath;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetectionScreen(
          screenText: screenText,
          fromHistory: false,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenshot.screenShotHandler(context, _onScreenShot);
    return new Container(
        width: 60.0,
        height: 60.0,
        decoration: new BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(0.0, 10.0),
            ),
          ],
        ),
        child: new IconButton(
          icon: Icon(Icons.camera_alt),
          tooltip: 'Detect text',
          onPressed: () => _startScreenShot(context),
          color: Colors.white,
          iconSize: 30,
        ));
  }
}
