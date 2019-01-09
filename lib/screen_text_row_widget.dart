import 'package:flutter/material.dart';
import 'dart:io';

import 'package:screengrabtext/detection_screen.dart';
import 'package:screengrabtext/screen_text_provider.dart';

class ScreenTextRow extends StatelessWidget {
  final ScreenText screenText;

  ScreenTextRow(this.screenText);

  @override
  Widget build(BuildContext context) {
    final textThumbnail = new Container(
        margin: new EdgeInsets.symmetric(vertical: 16.0),
        alignment: FractionalOffset.centerLeft,
        child: new Image.file(File(screenText.imagepath),
            height: 92.0, width: 92.0));

    final textCard = new Container(
      height: 124.0,
      width: 290,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: Colors.black54,
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
        child: new Text(
          screenText.text,
          style: new TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.w400),
          maxLines:6,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    return new InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetectionScreen(
                    screenText: screenText,
                    fromHistory: true,
                  )),
        );
      },
      child: new Container(
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
