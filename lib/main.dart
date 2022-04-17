import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/event_model.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/screens/chats/all_chats_page.dart';
import 'package:fluttergistshop/screens/profile/profile.dart';
import 'package:fluttergistshop/screens/room/upcomingRooms/upcoming_events.dart';
import 'package:fluttergistshop/services/dynamic_link_services.dart';
import 'package:fluttergistshop/services/room_api.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/theme.dart';
import '/utils/utils.dart';
import 'bindings.dart';
import 'controllers/auth_controller.dart';
import 'controllers/room_controller.dart';
import 'controllers/user_controller.dart';
import 'screens/orders/orders_sceen.dart';

AndroidNotificationChannel channel = channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final UserController _userController = Get.find<UserController>();
final RoomController _homeController = Get.find<RoomController>();
final AuthController authController = Get.put(AuthController());
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
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId(oneSignalAppID);
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
    printOut("A  notification ${event.notification.additionalData!}");
    printOut("A  onChatPage ${_homeController.onChatPage.value}");
    if (event.notification.additionalData!["screen"] == "ChatScreen" &&
        _homeController.onChatPage.value == true) {
      printOut("A chatScreen notification");
      event.complete(null);
    } else {
      printOut("not A chatScreen notification");
      event.complete(event.notification);
    }
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.

    printOut(
        'One signal Notification clicked ${result.notification.additionalData}');
    redirectToRooms(result.notification.additionalData!);
    handleNotificationOneSignal(result.notification);
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
          importance: Importance.high,
          priority: Priority.high,
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
  String screen = mess["screen"];
  String id = mess["id"];

  if (screen == 'ChatScreen') {
    Get.to(AllChatsPage());
  } else if (screen == "ProfileScreen") {
    _userController.getUserProfile(id);
    Get.to(Profile());
  } else if (screen == "RoomScreen") {
    _homeController.joinRoom(id);
  } else if (screen == "EventScreen") {
    EventModel roomModel =
        EventModel.fromJson(await RoomAPI().getEventById(id));
    Get.to(() => UpcomingEvents(roomModel: roomModel));
  } else if (screen == "OrderScreen") {
    Get.to(OrdersScreen());
  }
}

Future onSelectNotification(String payload) async {
  goToPageFromNotification(payload);
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    DynamicLinkService().handleDynamicLinks();
    _runWhileAppIsTerminated();
  }

  void _runWhileAppIsTerminated() async {
    var details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details!.didNotificationLaunchApp) {
      if (details.payload != null) {
        final prefs = await SharedPreferences.getInstance();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("------------------------- $state");
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            title: appName,
            debugShowCheckedModeBanner: false,
            theme: theme(),
            initialBinding: AuthBinding(),
            home: authController.handleAuth(),
          );
        });
  }
}
