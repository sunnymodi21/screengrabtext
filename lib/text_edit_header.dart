import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

import 'package:screengrabtext/screen_text_provider.dart';

class TextEditHeader extends StatelessWidget{
  final ScreenText screenText;

  TextEditHeader(this.screenText);

  Column buildButtonColumn(IconData icon, String label, onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new IconButton(
        iconSize: 20,
        tooltip: label,
        icon: Icon(icon),
          onPressed: onTap,
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {

        
    _onCopy(){
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Copied"),
        duration: Duration(seconds: 1),
      ));
      Clipboard.setData(new ClipboardData(text: screenText.text));
    }
    
    _onDelete() async {
      ScreenTextProvider screenTextDb = new ScreenTextProvider();
      await screenTextDb.delete(screenText.id);
      Navigator.of(context).pop();
    }

  _onShare(){
    final RenderBox box = context.findRenderObject();
    Share.share(screenText.text,
      sharePositionOrigin:
          box.localToGlobal(Offset.zero) &
              box.size);
    }

    return new Material(
      type: MaterialType.transparency,

      child: new Container(
        height: 53.0,
        width: MediaQuery.of(context).size.width,
        decoration: new ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.vertical(top: new Radius.circular(8.0)),
            side: BorderSide(width: 2.0, color: Colors.grey)),
          //borderRadius: new BorderRadius.vertical(top: Radius.circular(8.0), bottom: Radius.circular(8.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildButtonColumn(Icons.content_copy, 'Copy', _onCopy),
            buildButtonColumn(Icons.delete_forever, 'Delete', _onDelete),
            buildButtonColumn(Icons.share, 'Share', _onShare),
          ],
        ),
        // decoration: new BoxDecoration(
        //   color: Colors.white,
        //   shape: BoxShape.rectangle,
        //   borderRadius: new BorderRadius.vertical(top: Radius.circular(8.0), bottom: Radius.circular(8.0)),
        //   border: Border(
        //     top: BorderSide(width: 2.0, color: Colors.lightBlue),
        //     left: BorderSide(width: 2.0, color: Colors.lightBlue),
        //     right: BorderSide(width: 2.0, color: Colors.lightBlue),
        //   ),
        // ),
      ),
    );
  }
}
