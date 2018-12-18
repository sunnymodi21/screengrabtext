import 'package:flutter/material.dart';
import 'package:screengrabtext/screen_text_provider.dart';
import 'dart:io';

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
                  File imgFile = new File(item.imagepath);
                  items.add(
                    new ListTile(
                      leading: new Icon(Icons.home),
                      title: new Text(item.text.substring(0, 10)+'.....')
                    )
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