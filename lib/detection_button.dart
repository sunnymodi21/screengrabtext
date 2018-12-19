import 'package:flutter/material.dart';
import 'package:screengrabtext/screen_shot.dart';
import 'package:screengrabtext/detection_screen.dart';

class DetectionButton extends StatelessWidget {

  _startScreenShot(BuildContext context){
    ScreenShot screenshot = new ScreenShot();
    screenshot.startScreenShot(context, _onScreenShot);
  }

  _onScreenShot(BuildContext context, String imagePath){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetectionScreen(imagePath: imagePath, fromHistory: false,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 60.0,
      height: 60.0,
      margin: new EdgeInsets.only(left:MediaQuery.of(context).size.width-80,top:MediaQuery.of(context).size.height-160),
      decoration: new BoxDecoration(
        color: Colors.blueGrey,
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
            )
    );
  }
}
