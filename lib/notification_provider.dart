import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:screengrabtext/screen_text_provider.dart';
import 'package:screengrabtext/detection_screen.dart';
import 'package:screengrabtext/text_detector.dart';

class NotificationProvider {
  BuildContext context;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationDetails platformChannelSpecifics;
  ScreenText screenText;

  NotificationProvider(){
    flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    AndroidNotificationDetails androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    "com.inlogica.screengrabtext/notify", "screenshot","on Screenshot", importance: Importance.Max, priority: Priority.High);
    IOSNotificationDetails iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetectionScreen(screenText)),
    );
  }

  show(BuildContext mainContext, String imagePath) async {
    context = mainContext;
    TextDetector textDetector = new TextDetector();
    screenText = await textDetector.detectText(imagePath);
    flutterLocalNotificationsPlugin.show(
    0, 'ScreenShot done', 'Click to copy', platformChannelSpecifics);
  }
}