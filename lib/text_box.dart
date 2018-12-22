import 'package:flutter/material.dart';

import 'package:screengrabtext/text_edit_widget.dart';
import 'package:screengrabtext/screen_text_provider.dart';

class TextBox extends StatelessWidget{
  final ScreenText screenText;

  TextBox(this.screenText);

  @override
  Widget build(BuildContext context){
    return new Material(
      type: MaterialType.transparency,
      child: new GestureDetector (
        onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TextEdit(screenText)),
          );
        },
        child: new Container(
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border.all(width: 2.0, color: Colors.grey),
        ),
          child: new Container(
            padding: new EdgeInsets.all(10),
            child: Text(screenText.text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.normal
              ),
            ),
          ),
        ),
      ),
    );
  }
}
