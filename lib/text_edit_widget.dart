import 'package:flutter/material.dart';

import 'package:screengrabtext/screen_text_provider.dart';

class TextEdit extends StatefulWidget {
  final ScreenText screenText;

  TextEdit(this.screenText);

  @override
  _TextEditState createState() => new _TextEditState();
}

class _TextEditState extends State<TextEdit> {
  TextEditingController _controller;

  _onSave(text) async {
    ScreenTextProvider screenTextDb = new ScreenTextProvider();
    ScreenText editScreenText = widget.screenText;
    editScreenText.text = text;
    await screenTextDb.update(editScreenText);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _controller = new TextEditingController(text: widget.screenText.text);
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: ()=>_onSave(_controller.text),
              tooltip: 'Save',
            ),
          ]
      ),
      body: new Container(
        child: new TextField(
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _controller,
          scrollPadding: EdgeInsets.all(120),
          decoration: new InputDecoration(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.all(10),
            focusedBorder: new OutlineInputBorder(
              borderSide: new BorderSide(
                width: 2.0,
                color: Colors.grey
              ),
              borderRadius: BorderRadius.circular(0),
            ),
            border: new OutlineInputBorder(
              borderSide: new BorderSide(
                width: 2.0,
                color: Colors.grey
              ),
              borderRadius: BorderRadius.circular(0),
            )
          ),
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.normal
          )
        ),
      ),
    );
  }
}
