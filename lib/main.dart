import 'package:flutter/material.dart';
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
        primarySwatch: Colors.lightBlue,
      ),
      home: new MyHomePage(),
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
    var screenShotWid;
    if(screenShotPath != ''){
      File imgFile = new File(screenShotPath);
      screenShotWid = new Container(
                    child: new Image.file(imgFile),
                    width: (MediaQuery.of(context).size.width*0.6),
                    height: (MediaQuery.of(context).size.height*0.55),
                  );
                  } else {
      screenShotWid = new Container(
                    child: new Text('No Image'),
                    width: (MediaQuery.of(context).size.width*0.6),
                    height: (MediaQuery.of(context).size.height*0.55),
                  );
    }
    return RepaintBoundary(
          key: previewContainer,
          child: new GestureDetector(
              onTap: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
            child: new Scaffold(
            appBar: new AppBar(
              title: new Text('Screenshot'),
            ),
            body: new Container(
                child: new ListView (
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: _startScreenShot,
                      child: const Text('Take a Screenshot'),
                    ),
                    screenShotWid,
                    new TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 7,
                      controller: _controller,
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
            ),
          )
        );
  }

  // copyToClipboard(){
  //   Clipboard.setData(new ClipboardData(text: detectedText));
  // }
  
  detectText(String imagePath) async{
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath(imagePath);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);
    String text = visionText.text;
    setState(() {
      screenShotPath = imagePath;
      detectedText = text;
       _controller = new TextEditingController(text:text);
    });
  }
}