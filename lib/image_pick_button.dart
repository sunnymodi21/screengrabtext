import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:screengrabtext/detection_screen.dart';
import 'package:screengrabtext/screen_text_provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    ScreenText screenText = new ScreenText();
      screenText.imagepath = image.path;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetectionScreen(
            screenText: screenText,
            fromHistory: false,
          )
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}