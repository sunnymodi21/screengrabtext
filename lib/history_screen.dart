import 'package:flutter/material.dart';
import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/card_widget.dart';

class HistoryScreen extends StatelessWidget {
  final ScreenTextProvider screenTextDb = new ScreenTextProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: Center(
        child: FutureBuilder<List<ScreenText>>(
            future: screenTextDb.getAllScreenText(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //new Column(children: drawerOptions)
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
      ),
    );
  }
}