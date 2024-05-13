// ignore_for_file: unused_import

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_avisena/Screens/HomePage/homepage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Helperfunctions.dart';
import 'Screens/LoginPage/login.dart';
import 'Screens/OnboardPage/onboard.dart';
import 'components/animated_splash_screen.dart';
import 'components/localnotification.dart';
import 'package:firebase_core/firebase_core.dart';

import 'const.dart';

saveNotificationsToDevice(RemoteMessage message) async {
  var payload = message.data;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  List<String> allnotifications =
      await HelperFunctions.getUserNotifications() ?? [];

  List<String> newnotifications = [];
  for (var oldnoti in allnotifications) {
    newnotifications.add(oldnoti);
  }
  String title = payload['title'] ?? message.notification?.title;
  String body = payload['body'] ?? message.notification?.body;
  String thismessage = payload['thismessage'] ?? "";
  DateFormat dateFormat = DateFormat("HH:mm dd-MM-yyyy");
  String formatDate = dateFormat.format(DateTime.now());
  // String thisnow = DateTime.parse("$now").toString();
  // String datetime =
  //     "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()} ${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}";
  newnotifications.add("[$title,$body,$thismessage,$formatDate,]");
  await HelperFunctions.saveUserNotifications(newnotifications);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('Handling a background message ${message.messageId}');
  print("data == ${message.notification?.title}");
  var iOSChannelSpecifics = IOSInitializationSettings();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: iOSChannelSpecifics);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // save notification to the drawer
  await saveNotificationsToDevice(message);
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) async {
    if (message != null) {
      await saveNotificationsToDevice(message);
      // PushNotificationService().serialiseAndNavigate(message);
    }
  });
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ); // To turn off landscape mode

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

Route _generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return CupertinoPageRoute(
          builder: (_) => OnboardPage(), settings: settings);
    case '/LOGIN':
      return CupertinoPageRoute(
          builder: (_) => LoginPage(), settings: settings);
    // case '/REGISTER_PAGE':
    //   return CupertinoPageRoute(
    //       builder: (_) => RegisterPage(), settings: settings);
    // case '/MAIN_UI':
    //   return CupertinoPageRoute(
    //       builder: (_) => LoginSignupPage(), settings: settings);
    // case '/NOTI_DETAILS':
    //   return CupertinoPageRoute(
    //       builder: (_) => NotificationDetailsPage(), settings: settings);
    case '/INDEX':
      return CupertinoPageRoute(builder: (_) => HomePage(), settings: settings);
    // case '/LOCATION_PAGE':
    //   return CupertinoPageRoute(
    //       builder: (_) => LocationPage(), settings: settings);
    // default:
    //   return CupertinoPageRoute(
    //       builder: (_) => AnimatedSplashScreen(), settings: settings);

  }
  throw '';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocalNotificationService.initialize(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AviHealth',
        theme: ThemeData(
          primaryColor: violet,
        ),
        home: AnimatedSplashScreen(),
        // home: MyHomePage(title: 'truecare2u',),
        onGenerateRoute: _generateRoute,
        initialRoute: '/');
  }
}
