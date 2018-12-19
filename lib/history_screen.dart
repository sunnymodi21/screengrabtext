import 'package:flutter/material.dart';
import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/screen_text_row_widget.dart';
import 'package:screengrabtext/detection_button.dart';

class HistoryScreen extends StatelessWidget {
  final ScreenTextProvider screenTextDb = new ScreenTextProvider();

  @override
  Widget build(BuildContext context) {
    return new Stack(
        children: <Widget>[
          FutureBuilder<List<ScreenText>>(
            future: screenTextDb.getAllScreenText(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var items = <Widget>[];
                snapshot.data.forEach((item){
                  items.add(
                    new ScreenTextRow(id: item.id, imagePath: item.imagepath, text: item.text)
                  );
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
        ]
      );
  }
}
