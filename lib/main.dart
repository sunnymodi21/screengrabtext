import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
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
  Uint8List screenShot;
  String detectedText= '';

  @override
  Widget build(BuildContext context) {
    var screenShotWid;
    if(screenShot != null){
      screenShotWid = new Image.memory(screenShot);
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
                onPressed: takeScreenShot,
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

  // getPermissionStatus() async {
  //   List<Permissions> permissions = await Permission.getPermissionStatus([PermissionName.Storage]);
  //   permissions.forEach((permission) {
  //     if(permission.permissionStatus.toString() =='PermissionStatus.noAgain' ||  permission.permissionStatus.toString() =='PermissionStatus.deny'){
  //       requestPermission(permission);
  //     }
  //   });
  // }

  // requestPermission(permission) async {
  //   await Permission.requestSinglePermission(PermissionName.Storage);
  // }

  takeScreenShot() async{
    RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    //getPermissionStatus();
    final directory = (await getApplicationDocumentsDirectory()).path;
    var now = new DateTime.now();
    var fileName= "screenshot"+now.millisecondsSinceEpoch.toString()+".png";
    File imgFile =new File('$directory/$fileName');
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    await imgFile.writeAsBytes(pngBytes);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imgFile);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);
    String text = visionText.text;
    setState(() {
      screenShot=pngBytes;
      detectedText = text;
    });
    print('text detect:'+ text);
    //Clipboard.setData(new ClipboardData(text: 'Data'));
  }
}