import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/screens/auth/sign_up_screen.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:get/get.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => SignUpScreen());
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 16.sp,
              color: primarycolor,
            ),
          ),
        ),
      ],
    );
  }
}
