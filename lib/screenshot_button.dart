import 'package:flutter/material.dart';

class ScreenShotButton extends StatelessWidget {
  final startScreenShot;
  
  ScreenShotButton(this.startScreenShot);
  
  @override
  Widget build(BuildContext context) {
    return 
      new Container(
        width: 50.0,
        height: 50.0,
        margin: new EdgeInsets.only(bottom: 10.0),
        child: new FloatingActionButton(
          heroTag: "detectionbutton",
          backgroundColor: Colors.blue,
          tooltip: 'Detect text',
          onPressed: () => startScreenShot(),
          shape: new CircleBorder(),
          child: Icon(
            Icons.crop_free,
            color: Colors.white,
            size: 27,
          ),
        ));
  }
}