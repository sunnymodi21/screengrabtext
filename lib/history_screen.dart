import 'package:flutter/material.dart';
import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/screen_text_row_widget.dart';
import 'package:screengrabtext/detection_buttons.dart';

class HistoryScreen extends StatelessWidget {
  final ScreenTextProvider screenTextDb = new ScreenTextProvider();

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: const Alignment(0.85, 0.9),
      children: <Widget>[
      FutureBuilder<List<ScreenText>>(
        future: screenTextDb.getAllScreenText(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var items = <Widget>[];
            snapshot.data.forEach((item) {
              ScreenText screenText = new ScreenText();
              screenText.id = item.id;
              screenText.imagepath = item.imagepath;
              screenText.text = item.text;
              items.add(new ScreenTextRow(screenText));
            });
            return new ListView(children: items);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      ),
      new DetectionButton(),
    ]);
  }
}
