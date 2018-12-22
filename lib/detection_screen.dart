import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/text_edit_header.dart';
import 'package:screengrabtext/text_box.dart';

class DetectionScreen extends StatefulWidget {
  final ScreenText screenText;
  final bool fromHistory;

  DetectionScreen({@required this.fromHistory, this.screenText});

  @override
  _DetectionScreenState createState() => new _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  ScreenText screenTextState = new ScreenText();
  double dragOffset = 450.0;

  @override
  void initState() {
    super.initState();
    if (widget.fromHistory) {
      setState(() {
        screenTextState = widget.screenText;
      });
    } else
      detectText(widget.screenText.imagepath);
  }

  onDragChange(details){
    print(details.offset.dy);
    setState(() {
      dragOffset = details.offset.dy;
    });
  }

  Column textWindow() {
    return new Column(
      children: <Widget>[
        new TextEditHeader(screenTextState),
        new TextBox(screenTextState)
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    Container screenShotWid;
    if (widget.screenText.imagepath != '') {
      File imgFile = new File(widget.screenText.imagepath);
      screenShotWid = new Container(
        child: new Image.file(imgFile),
        width: (MediaQuery.of(context).size.width),
        height: (MediaQuery.of(context).size.height - 80),
      );
    } else {
      screenShotWid = new Container(child: new Text('No Image'));
    }

    return new Scaffold(
      appBar: AppBar(
        title: Text("Detection"),
      ),
      body: new ListView(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              screenShotWid,
              new Positioned(
                top: dragOffset,
                child: new Container(
                  child:new Draggable(
                    axis: Axis.vertical,
                    child: textWindow(),
                    feedback: textWindow(),
                    childWhenDragging: Container(),
                    onDragEnd: onDragChange,
                  ),
                ),
            ),
              //new DetectionButton(),
            ],
          ),
        ],
      ),
    );
  }

  detectText(String imagePath) async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFilePath(imagePath);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    var orderedText = {};
    for (TextBlock block in visionText.blocks) {
      final boundingBox = block.boundingBox;
      final String blockText = block.text;
      if (blockText.length > 2) {
        int position =
            int.parse(boundingBox.top.toString() + boundingBox.left.toString());
        orderedText[position] = blockText;
      }
    }
    String detectedText = '';
    var sortedKeys = orderedText.keys.toList();
    sortedKeys.sort();
    sortedKeys.forEach((key) {
      detectedText = detectedText + orderedText[key] + '\n';
    });
    ScreenText screenText = new ScreenText();
    screenText.imagepath = imagePath;
    screenText.text = detectedText;
    ScreenTextProvider screenTextDb = new ScreenTextProvider();
    screenText = await screenTextDb.insert(screenText);
    setState(() {
      screenTextState = screenText;
    });
  }
}
