import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/bindings.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/screens/auth/login.dart';
import 'package:fluttergistshop/services/api_calls.dart';
import 'package:fluttergistshop/theme.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:fluttergistshop/widgets/async_progress_dialog.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
