import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifications/configs/async_progress_dialog.dart';
import 'package:notifications/screens/main_page.dart';
import 'package:notifications/services/api_call.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configs/configs.dart';

AndroidNotificationChannel channel = channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  oneSignal();
  runApp(MyApp());
}

Future<void> oneSignal() async {
  initOneSignal();
  oneSignalObservers();
}

initOneSignal() {
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId(one_signal_id);
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
}

oneSignalObservers() {
  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.
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
          icon: '@mipmap/ic_stat_onesignal_default',
        ),
      ),
      payload: " ${osNotification.additionalData!['screen']}  "
          "${osNotification.additionalData!['id']} ${osNotification.additionalData!['paidroom'] ?? ""}");
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
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _runWhileAppIsTerminated();
    _emailCheck();
  }

  _emailCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    if (email != null && email.isNotEmpty) {
      return true;
    }
    return false;
  }

  void _runWhileAppIsTerminated() async {
    var details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details!.didNotificationLaunchApp) {}
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
    return MaterialApp(
      title: 'Notifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: _emailCheck(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (asyncSnapshot.hasData) {
            if (asyncSnapshot.data == true) {
              return MainPage();
            }
            return HomePage();
          }
          return Container();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController email = TextEditingController();
  String errors = "";
  static final _formLoginkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formLoginkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter your email to start receiving notifications",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  labelText: "Email",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (email.text.isEmpty) {
                    return "Email is required";
                  } else if (!emailValidatorRegExp.hasMatch(email.text)) {
                    return "Enter valid email";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () => signInButtonCallback(context),
                  child: Text(
                    "Proceed >>",
                    style: TextStyle(fontSize: 21),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInButtonCallback(BuildContext context) async {
    if (_formLoginkey.currentState!.validate()) {
      var userPlayerId = await OneSignal.shared.getDeviceState();

      String snackbarMessage = "Email saved";
      try {
        var login = ApiCalls.saveUserData(
            {"email": email.text, "mobileId": userPlayerId});
        await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              login,
              message: const Text("Please wait.."),
              onError: (e) {
                snackbarMessage = "Error happened";
              },
            );
          },
        );
      } catch (e, s) {
        print("Error in sign in button callback $e $s");
      } finally {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              snackbarMessage,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("email", email.text);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    } else {}
  }
}
