import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/screens/auth/forgot_password.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:fluttergistshop/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

class Login extends StatelessWidget {
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();

  final AuthController authController = Get.put(AuthController());
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
                        press: signInButtonCallback,
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
      controller: passwordFieldController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter your password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (passwordFieldController.text.isEmpty) {
          return kPassNullError;
        } else if (passwordFieldController.text.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter your email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Ionicons.mail_open),
      ),
      validator: (value) {
        if (emailFieldController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(emailFieldController.text)) {
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signInButtonCallback() async {
    if (_formLoginkey.currentState!.validate()) {
    } else {}
  }
}
