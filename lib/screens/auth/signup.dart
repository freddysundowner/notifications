import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/widgets/widgets.dart';
import 'package:ionicons/ionicons.dart';

import '../../utils/utils.dart';

class SignUpScreen extends StatelessWidget {
  final _formSingupKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController namesFieldController = TextEditingController();
  final TextEditingController usernameFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController confirmPasswordFieldController =
      TextEditingController();

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    confirmPasswordFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 20.sp),
                Text(
                  "Create Account",
                  style: headingStyle,
                ),
                SizedBox(height: 20.h),
                Form(
                  key: _formSingupKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sm),
                    child: Column(
                      children: [
                        TextFormField(
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
                            } else if (!emailValidatorRegExp
                                .hasMatch(emailFieldController.text)) {
                              return kInvalidEmailError;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: 30.sp),
                        TextFormField(
                          controller: namesFieldController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Enter your username",
                            labelText: "Username",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(Icons.supervised_user_circle),
                          ),
                          validator: (value) {
                            if (namesFieldController.text.isEmpty) {
                              return kUsernameNullError;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: 30.sp),
                        TextFormField(
                          controller: usernameFieldController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Enter Full Names",
                            labelText: "Full names",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(Icons.supervised_user_circle),
                          ),
                          validator: (value) {
                            if (usernameFieldController.text.isEmpty) {
                              return kFnamesNullError;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: 30.sp),
                        buildPasswordFormField(),
                        SizedBox(height: 30.sp),
                        buildConfirmPasswordFormField(),
                        SizedBox(height: 40.sp),
                        DefaultButton(
                          text: "Sign up",
                          press: signUpButtonCallback,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "By continuing your confirm that you agree \nwith our Terms and Conditions",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildConfirmPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordFieldController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Re-enter your password",
        labelText: "Confirm Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (confirmPasswordFieldController.text.isEmpty) {
          return kPassNullError;
        } else if (confirmPasswordFieldController.text !=
            passwordFieldController.text) {
          return kMatchPassError;
        } else if (confirmPasswordFieldController.text.length < 8) {
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

  Future<void> signUpButtonCallback() async {
    if (_formSingupKey.currentState!.validate()) {}
  }
}
