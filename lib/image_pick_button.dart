import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:screengrabtext/detection_screen.dart';
import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/text_detector.dart';

class ImagePickerButton extends StatefulWidget {
  final String option;

  ImagePickerButton(this.option);

  @override
  _ImagePickerButtonState createState() => new _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  
  Future getImage() async {
    ImageSource source = widget.option=='camera'? ImageSource.camera: ImageSource.gallery;
    File image = await ImagePicker.pickImage(source: source);
    if(image!=null){      
      ScreenText screenText = new ScreenText();
      TextDetector textDetector = new TextDetector();
      screenText = await textDetector.detectText(image.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetectionScreen(screenText)
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 50.0,
          height: 50.0,
          margin: new EdgeInsets.only(bottom: 15.0),
          child: new FloatingActionButton(
            heroTag: widget.option,
            backgroundColor: Colors.blue,
            onPressed: getImage,
            tooltip: 'Get Image',
            shape: new CircleBorder(),
            child: Icon(
              widget.option=='camera'? Icons.camera_alt:Icons.photo_library,
              color: Colors.white,
              size: 27,
            ),
        ));
  }
}