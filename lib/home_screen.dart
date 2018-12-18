import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

import 'package:screengrabtext/screen_text_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String screenShotPath = '';
  static const platform = const MethodChannel('com.inlogica.screengrabtext/takeshot');
  TextEditingController _controller;

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
                    width: (MediaQuery.of(context).size.width*0.7),
                    height: (MediaQuery.of(context).size.height*0.6),
                  );
                  } else {
      screenShotWid = new Container(
                    child: new Text('No Image'),
                    width: (MediaQuery.of(context).size.width*0.7),
                    height: (MediaQuery.of(context).size.height*0.6),
                  );
    }
    return new Container(
      child: new GestureDetector(
        onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new ListView (
          children: <Widget>[
            new RaisedButton(
              onPressed: _startScreenShot,
              child: const Text('Take a Screenshot'),
            ),
            screenShotWid,
            new TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _controller,
              scrollPadding: EdgeInsets.all(120),
              decoration: new InputDecoration(
                fillColor: Color(0xFCFCF4E0),
                filled: true,
                contentPadding: EdgeInsets.all(10),
                border: new OutlineInputBorder(
                  borderSide: new BorderSide(
                    width: 8.0, 
                    color: Colors.red
                  )
                ),
              ),
            ),
            // new RaisedButton(
            //         onPressed: copyToClipboard,
            //         child: const Text('Copy'),
            // ),
          ],
        ),
      ),
    );
  }

  copyToClipboard(){
    Clipboard.setData(new ClipboardData(text: _controller.text));
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
        orderedText[boundingBox.top]= blockText;
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
       _controller = new TextEditingController(text:text);
    });
  }
}