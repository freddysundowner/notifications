import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/screens/auth/forgot_password.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:fluttergistshop/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

class Login extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final _formLoginkey = GlobalKey<FormState>();

  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Welcome Back",
                  style: headingStyle,
                ),
                Text(
                  "Sign in with your email and password",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Form(
                  key: _formLoginkey,
                  child: Column(
                    children: [
                      buildEmailFormField(),
                      SizedBox(height: 30.h),
                      buildPasswordFormField(),
                      SizedBox(height: 30.h),
                      buildForgotPasswordWidget(context),
                      SizedBox(height: 30.h),
                      Obx(() => Text(
                            authController.error.value,
                            style: TextStyle(color: Colors.red),
                          )),
                      DefaultButton(
                        text: "Sign in",
                        press: () => signInButtonCallback(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                NoAccountText(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildForgotPasswordWidget(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        GestureDetector(
          onTap: () {
            Get.to(() => ForgotPasswordScreen());
          },
          child: Text(
            "Forgot Password",
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: authController.passwordFieldController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter your password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (authController.passwordFieldController.text.isEmpty) {
          return kPassNullError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      controller: authController.emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter your email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Ionicons.mail_open),
      ),
      validator: (value) {
        if (authController.emailFieldController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp
            .hasMatch(authController.emailFieldController.text)) {
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signInButtonCallback(BuildContext context) async {
    if (_formLoginkey.currentState!.validate()) {
      String snackbarMessage = "";
      try {
        var login = authController.authenticate();
        await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              login,
              message: Text("Signing in to your account"),
              onError: (e) {
                snackbarMessage = e.toString();
              },
            );
          },
        );
        snackbarMessage = authController.error.value;
      } finally {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    } else {}
  }
}
