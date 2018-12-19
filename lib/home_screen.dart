import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/text_edit_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String screenShotPath = '';
  String text= '';
  static const platform = const MethodChannel('com.inlogica.screengrabtext/takeshot');

  _startScreenShot() {
    platform.invokeMethod('startProjection');
    platform.setMethodCallHandler((MethodCall call) async {
      if(call.method=='onScreenShot') {
        print('location, ${call.arguments}');
        detectText(call.arguments);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Container screenShotWid;
    if(screenShotPath != ''){
      File imgFile = new File(screenShotPath);
      screenShotWid = new Container(
                    child: new Image.file(imgFile),
                    width: (MediaQuery.of(context).size.width),
                    height: (MediaQuery.of(context).size.height-80),
                  );
                  } else {
      screenShotWid = new Container(
                    child: new Text('No Image')
                  );
    }

    Container startDetection = new Container(
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
              onPressed: _startScreenShot,
              color: Colors.white,
              iconSize: 30,
            )
      );
      
    return new Container(
      child: new GestureDetector(
        onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new ListView (
          children: <Widget>[
            // new RaisedButton(
            //   onPressed: _startScreenShot,
            //   child: const Text('Take a Screenshot'),
            // ),
            new Stack(
              children: <Widget>[
                screenShotWid,
                //new TextEdit(text),
                startDetection
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  detectText(String imagePath) async{
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(imagePath);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);
    var orderedText={}; 
    for (TextBlock block in visionText.blocks) {
      final boundingBox = block.boundingBox;
      final String blockText = block.text;
      if(blockText.length>2){
        int position = int.parse(boundingBox.top.toString()+boundingBox.left.toString());
        orderedText[position]= blockText;
      }
    }
    String text = '';
    var sortedKeys = orderedText.keys.toList();
    sortedKeys.sort();
    sortedKeys.forEach((key){
      text = text+orderedText[key]+'\n';
    });
    ScreenText screenText = new ScreenText();
    screenText.imagepath = imagePath;
    screenText.text = text;
    ScreenTextProvider screenTextDb = new ScreenTextProvider();
    screenTextDb.insert(screenText);
    setState(() {
      screenShotPath = imagePath;
      text = text;
    });
  }
}
