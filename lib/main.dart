import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/screens/chats/all_chats_page.dart';
import 'package:fluttergistshop/screens/profile/profile.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/theme.dart';
import '/utils/utils.dart';
import 'bindings.dart';
import 'controllers/auth_controller.dart';

AndroidNotificationChannel channel = channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  oneSignal();

  runApp(MyApp());
}

Future<void> oneSignal() async {
  initOneSignal();
  oneSignalObservers();
}

initOneSignal() {
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(oneSignalAppID);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt.
// We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
}

oneSignalObservers() {
  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification

    //handleNotificationOneSignal(event.notification);
    event.complete(event.notification);
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.

    printOut(
        'One signal Notification clicked ${result.notification.additionalData}');
    redirectToRooms(result.notification.additionalData!);
    // handleNotificationOneSignal(result.notification);
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    // Will be called whenever the subscription changes
    // (ie. user gets registered with OneSignal and gets a user ID)
  });
}

Future<void> handleNotificationOneSignal(OSNotification osNotification) async {
  flutterLocalNotificationsPlugin.show(
      osNotification.hashCode,
      osNotification.title,
      osNotification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: " ${osNotification.additionalData!['screen']}  "
          "${osNotification.additionalData!['id']} ${osNotification.additionalData!['paidroom'] ?? ""}");
}

goToPageFromNotification(var payload) async {
  String screen;
  String id;
  bool paidroom = false;

  if (payload == null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var combinedString = prefs.getString("from_notification_class");
    var a = combinedString!.split(" ");
    screen = a[0];
    id = a[1];
  } else {
    var a = payload.split(" ");
    screen = a[0];
    id = a[1];
    if (a.length > 2) {
      paidroom = a[2] == "false" ? false : true;
    }
  }
  var msg = {"screen": screen, "id": id};
  await redirectToRooms(msg);
}

bool showloading = false;

Future redirectToRooms(Map<String, dynamic> mess) async {
  printOut('One signal Notification clicked redirecting');

  String screen = mess["screen"];
  String id = mess["id"];

  if (screen == 'ChatPage') {
    //  InboxItem item = await Database.getInboxItem(id);
    Get.to(() => AllChatsPage());
  } else if (screen == "ProfilePage") {
    //var user = await UserAPI().getUserProfile(id);

    Get.to(() => Profile());
  } else if (screen == "RoomScreen") {}
}

Future onSelectNotification(String payload) async {
  goToPageFromNotification(payload);
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: () => GetMaterialApp(
              navigatorKey: navigatorKey,
              title: appName,
              debugShowCheckedModeBanner: false,
              theme: theme(),
              initialBinding: AuthBinding(),
              home: authController.handleAuth(),
            ));
  }
}
