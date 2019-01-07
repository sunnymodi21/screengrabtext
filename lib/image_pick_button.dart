import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:screengrabtext/detection_screen.dart';
import 'package:screengrabtext/screen_text_provider.dart';

class ImagePickerButton extends StatefulWidget {
  @override
  _ImagePickerButtonState createState() => new _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  
  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
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
    return Container(
          width: 50.0,
          height: 50.0,
          margin: new EdgeInsets.only(bottom: 15.0),
          child: new FloatingActionButton(
            heroTag: "imagepickbutton",
            backgroundColor: Colors.blue,
            onPressed: getImage,
            tooltip: 'Pick Image',
            shape: new CircleBorder(),
            child: Icon(
              Icons.photo_library,
              color: Colors.white,
              size: 27,
            ),
        ));
  }
}