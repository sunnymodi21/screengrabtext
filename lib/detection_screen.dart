import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/text_edit_widget.dart';

class DetectionScreen extends StatefulWidget {
  final String imagePath;
  final bool fromHistory;
  final String text;

  DetectionScreen({@required this.fromHistory ,this.imagePath, this.text});
  
  @override
  _DetectionScreenState createState() => new _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  String text= '';

  @override
  Widget build(BuildContext context) {
    // if(widget.fromHistory){
    //   setState(() {
    //           text = widget.text;
    //         });
    // } else detectText(widget.imagePath);
    Container screenShotWid;
    if(widget.imagePath != ''){
      File imgFile = new File(widget.imagePath);
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
      
    return Scaffold(
      appBar: AppBar(
        title: Text("Detection"),
      ),
      body: new GestureDetector(
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
                //new DetectionButton(),
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
      text = text;
    });
  }
}
