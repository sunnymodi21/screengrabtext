import 'package:flutter/material.dart';
import 'dart:io';

import 'package:screengrabtext/detection_screen.dart';

class ScreenTextRow extends StatelessWidget {
  final String text;
  final String imagePath;
  final int id;
  
  ScreenTextRow({Key key, @required this.text, @required this.imagePath, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textThumbnail = new Container(
    margin: new EdgeInsets.symmetric(
      vertical: 16.0
    ),
    alignment: FractionalOffset.centerLeft,
    child: new Image.file(File(imagePath), height:92.0, width:92.0)
    );

    final textCard = new Container(
      height: 124.0,
      width: 290,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(  
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
      child: new Container(
        margin: new EdgeInsets.fromLTRB(40, 16, 20, 20),
        child:new Text(text.substring(0, 10) +'.....',
          style: new TextStyle(
                  color: const Color(0xffb6b2df),
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400),
        ),
      ),
    );

    return new InkWell(
      // When the user taps the button, show a snackbar
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetectionScreen(imagePath: imagePath, fromHistory: true, text: text)),
        );
      },
      child:new Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 10.0,
        ),
        child: new Stack(
          children: <Widget>[
            textCard,
            textThumbnail,
          ],
        ),
      ),
    );
  }
}
