import 'package:flutter/material.dart';
import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/screen_text_row_widget.dart';
import 'package:screengrabtext/detection_buttons.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => new _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with WidgetsBindingObserver {
  var screenTextState = <Widget>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        print('resume');
        ScreenTextProvider screenTextDb = new ScreenTextProvider();
        screenTextDb.getAllScreenText().then((historyData){
          var items = <Widget>[];
          historyData.forEach((item) {
            ScreenText screenText = new ScreenText();
            screenText.id = item.id;
            screenText.imagepath = item.imagepath;
            screenText.text = item.text;
            items.add(new ScreenTextRow(screenText));
          });
          setState(() {
            screenTextState = items;
          });
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.suspending:
        break;

    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenTextProvider screenTextDb = new ScreenTextProvider();
    screenTextDb.getAllScreenText().then((historyData){
      var items = <Widget>[];
      historyData.forEach((item) {
        ScreenText screenText = new ScreenText();
        screenText.id = item.id;
        screenText.imagepath = item.imagepath;
        screenText.text = item.text;
        items.add(new ScreenTextRow(screenText));
      });
      setState(() {
        screenTextState = items;
      });
    });
    return new Stack(
      alignment: const Alignment(0.85, 0.9),
      children: <Widget>[
      new ListView(children: screenTextState),
      new DetectionButton(),
    ]);
  }
}
