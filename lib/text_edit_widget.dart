import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextEdit extends StatefulWidget {
  final String text;

  TextEdit(this.text);

  @override
  _TextEditState createState() => new _TextEditState();
}

class _TextEditState extends State<TextEdit> {

  TextEditingController _controller;

  @override
  Widget build(BuildContext context){
    _controller = new TextEditingController(text: widget.text);
    return new TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _controller,
            scrollPadding: EdgeInsets.all(120),
            decoration: new InputDecoration(
              fillColor: Color(0xFCFCF4E0),
              filled: true,
              contentPadding: EdgeInsets.all(10),
              border: new OutlineInputBorder(
                borderSide: new BorderSide(
                  width: 8.0,
                ),
              ),
            ),
          );
          // new RaisedButton(
          //         onPressed: copyToClipboard,
          //         child: const Text('Copy'),
          // ),
  }

  copyToClipboard(){
    Clipboard.setData(new ClipboardData(text: _controller.text));
  }
}
