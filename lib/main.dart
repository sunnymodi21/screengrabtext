import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ScreenGrab Text',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Text Detection'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static GlobalKey previewContainer = new GlobalKey();
  String screenShotPath = '';
  String detectedText = '';
  static const platform = const MethodChannel('com.inlogica.screengrabtext/takeshot');

  _showNotification() {
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
    var screenShotWid;
    if(screenShotPath != ''){
      File imgFile = new File(screenShotPath);
      screenShotWid = new Image.file(imgFile);
    } else {
      screenShotWid = new Text('No Image');
    }

    return RepaintBoundary(
        key: previewContainer,
      child: new Scaffold(
      appBar: new AppBar(

        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
                onPressed: _showNotification,
              child: const Text('Take a Screenshot'),
            ),
            new Container(child: screenShotWid,
                          width: 300.0,
                          height: 350.0,),
            new Container(child: new Text(detectedText)),
        ],
        ),
      ),
    )
    );
  }

  detectText(String imagePath) async{
    //getPermissionStatus();
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(imagePath);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);
    String text = visionText.text;
    setState(() {
      screenShotPath = screenShotPath;
      detectedText = text;
    });
    print('text detect:'+ text);
    //Clipboard.setData(new ClipboardData(text: 'Data'));
  }
}