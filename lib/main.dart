import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/screens/home/home_page.dart';
import 'package:get/get.dart';

import '/theme.dart';
import '/utils/utils.dart';
import 'bindings.dart';
import 'controllers/auth_controller.dart';

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
              home: HomePage(),
            ));
  }
}
