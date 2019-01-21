import 'package:flutter/material.dart';
import 'dart:io';

import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/text_edit_header.dart';
import 'package:screengrabtext/text_box.dart';
import 'package:screengrabtext/ad_provider.dart';

class DetectionScreen extends StatefulWidget {
  final ScreenText screenText;

  DetectionScreen(this.screenText);

  @override
  _DetectionScreenState createState() => new _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  ScreenText screenTextState = new ScreenText();
  double dragOffset = 400.0;

  @override
  void initState() {
    
    AdProvider adProvider = new AdProvider();
    var targetingInfo  = adProvider.initialize();
    adProvider.loadInterstitial(targetingInfo);
    //adProvider.showIntertitial();
    super.initState();
      setState(() {
        screenTextState = widget.screenText;
      });
  }

  _onDragChange(details){
    setState(() {
      dragOffset = details.offset.dy*0.75;
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
                    onDragEnd: _onDragChange,
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
}
