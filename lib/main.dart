// ignore_for_file: unused_import

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_avisena/Screens/HomePage/homepage.dart';
import 'package:flutter_avisena/Screens/ProfilePage/component/language.dart';
import 'package:flutter_avisena/components/localization_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
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
import 'package:flutter_localizations/flutter_localizations.dart';
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
      return CupertinoPageRoute(builder: (_) => HomePage(name: '', phone: '', email: '', mrn: ''), settings: settings);
  // case '/LOCATION_PAGE':
  //   return CupertinoPageRoute(
  //       builder: (_) => LocationPage(), settings: settings);
  // default:
  //   return CupertinoPageRoute(
  //       builder: (_) => AnimatedSplashScreen(), settings: settings);

  }
  throw '';
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final storage = FlutterSecureStorage();

  Locale? localization;

  @override
  void initState() {
    getLanguage();
    super.initState();
  }

  getLanguage() async {
    var language = await storage.read(key: 'language');
    if (language != null) {
      setState(() {
        localization = LocalizationService.instance.getLocaleFromLanguage(language);
        LocalizationService.instance.changeLocale(language);
      });
    } else {
      setState(() {
        localization = LocalizationService.locales[0];
      });
    }
    // if (language != null) {
    //   print('Mobazane $localization');
    //   print('Aul $language');
    //   setState(() {
    //     if(language == 'English') {
    //       localization = LocalizationService.locales[0];
    //       print('apa $localization');
    //     } else {
    //       localization = LocalizationService.locales[1];
    //       print('siapa $localization');
    //     }
    //   });
    // } else {
    //   setState(() {
    //     localization = LocalizationService.locales[0];
    //     print('mana $localization');
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocalizationService(),
      locale: localization,
      fallbackLocale: LocalizationService.locales[0],
      debugShowCheckedModeBanner: false,
      title: 'AviHealth',
      theme: ThemeData(
        primaryColor: violet,
      ),
      // home: MyHomePage(),
      home: AnimatedSplashScreen(),
      // home: Language(name: 'name', email: 'email', phone: 'phone'),
      // home: MyHomePage(title: 'truecare2u',),
      onGenerateRoute: _generateRoute,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => AnimatedSplashScreen()),
        GetPage(name: '/language', page: () => Language(name: '', email: '', phone: '')),
      ],
    );
  }
}

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//
//   final storage = FlutterSecureStorage();
//
//   String? language;
//   String? global;
//
//   @override
//   void initState() {
//     super.initState();
//     initializeLanguageSettings();
//   }
//
//   void initializeLanguageSettings() async {
//     await defaultLanguage();
//     await changeLanguage();
//   }
//
//   // defaultLanguage() async {
//   //   var lang = await storage.read(key: 'language');
//   //   switch (lang) {
//   //     case "en" :
//   //       await storage.write(key: 'language', value: 'en');
//   //       await storage.write(key: 'global', value: 'US');
//   //       break;
//   //     case "ms" :
//   //       await storage.write(key: 'language', value: 'ms');
//   //       await storage.write(key: 'global', value: 'MY');
//   //       break;
//   //     default :
//   //       await storage.write(key: 'language', value: 'en');
//   //       await storage.write(key: 'global', value: 'US');
//   //   }
//   //   print('Current Language: $lang');
//   // }
//
//   Future<void> defaultLanguage() async {
//     var lang = await storage.read(key: 'language');
//     if (lang == null) {
//       await storage.write(key: 'language', value: 'en');
//       await storage.write(key: 'global', value: 'US');
//     }
//   }
//
//   Future<void> changeLanguage() async {
//     language = await storage.read(key: 'language');
//     global = await storage.read(key: 'global');
//     if (language == null || global == null) {
//       language = 'en';
//       global = 'US';
//     }
//     setState(() {});
//     print('Language $language, $global');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//   LocalNotificationService.initialize(context);
//
//   String localeLanguage = language ?? 'en';
//   String localeGlobal = global ?? 'US';
//
//   return MaterialApp(
//       locale: Locale(localeLanguage, localeGlobal),
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('en'),
//         Locale('ms'),
//       ],
//       debugShowCheckedModeBanner: false,
//       title: 'AviHealth',
//       theme: ThemeData(
//         primaryColor: violet,
//       ),
//
//       // home: MyHomePage(),
//       home: AnimatedSplashScreen(),
//       // home: MyHomePage(title: 'truecare2u',),
//       onGenerateRoute: _generateRoute,
//       initialRoute: '/'
//     );
//   }
// }