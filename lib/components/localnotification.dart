// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// // class LocalNotification {
// //   static FlutterLocalNotificationsPlugin flutterNotificationPlugin;
// //   static AndroidNotificationDetails androidSettings;
//
// //   static Initializer() {
// //     flutterNotificationPlugin = FlutterLocalNotificationsPlugin();
// //     androidSettings = AndroidNotificationDetails(
// //         "111", "Background_task_Channel", channelDescription:"Channel to test background task",
// //         importance: Importance.max, priority: Priority.max);
// //     var androidInitialization = AndroidInitializationSettings('app_icon');
// //     var initializationSettings =
// //         InitializationSettings(android:androidInitialization, iOS:null);
// //     flutterNotificationPlugin.initialize(initializationSettings,
// //         onSelectNotification: onNotificationSelect);
// //   }
//
// //   static Future<void> onNotificationSelect(String payload) async {
// //     print(payload);
// //   }
//
// //   static ShowOneTimeNotification(DateTime scheduledDate) async {
// //     var notificationDetails = NotificationDetails(android:androidSettings, iOS:null);
// //     await flutterNotificationPlugin.zonedSchedule(1, "Incoming Call",
// //         "Tap to open", scheduledDate, notificationDetails,
// //         androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime);
// //   }
// // }
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static void initialize(BuildContext context) {
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: AndroidInitializationSettings("app_icon"));
//
//     _notificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? data) async {
//       print("data notification $data");
//     });
//   }
//
//   static void display(RemoteMessage message) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//
//       final NotificationDetails notificationDetails = NotificationDetails(
//           android: AndroidNotificationDetails(
//         'high_importance_channel', // id
//         'High Importance Notifications',
//         importance: Importance.max,
//         priority: Priority.max,
//       ));
//
//       await _notificationsPlugin.show(
//         id,
//         message.notification?.title,
//         message.notification?.body,
//         notificationDetails,
//         payload: message.data["route"],
//       );
//     } on Exception catch (e) {
//       print(e);
//     }
//   }
// }
