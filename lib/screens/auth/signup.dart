import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../utils/utils.dart';

class SignUpScreen extends StatelessWidget {
  final _formSingupKey = GlobalKey<FormState>();

  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {}

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
                        buildEmailFormField(),
                        SizedBox(height: 30.sp),
                        TextFormField(
                          controller: authController.fnameFieldController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Enter your firstname",
                            labelText: "First Name",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(Icons.supervised_user_circle),
                          ),
                          validator: (value) {
                            if (authController
                                .fnameFieldController.text.isEmpty) {
                              return kUsernameNullError;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: 30.sp),
                        TextFormField(
                          controller: authController.lnameFieldController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Enter your lastname",
                            labelText: "Last Name",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(Icons.supervised_user_circle),
                          ),
                          validator: (value) {
                            if (authController
                                .lnameFieldController.text.isEmpty) {
                              return kUsernameNullError;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: 30.sp),
                        TextFormField(
                          controller: authController.usernameFieldController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Enter your username",
                            labelText: "Username",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(Icons.supervised_user_circle),
                          ),
                          validator: (value) {
                            if (authController
                                .usernameFieldController.text.isEmpty) {
                              return kUsernameNullError;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: 30.sp),
                        TextFormField(
                          controller: authController.bioFieldController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 3,
                          decoration: const InputDecoration(
                            hintText: "Enter your bio",
                            labelText: "Bio",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(Icons.description),
                          ),
                          validator: (value) {
                            if (authController
                                .bioFieldController.text.isEmpty) {
                              return kUsernameNullError;
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
                          press: () => signUpButtonCallback(context),
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
    return Obx(
      () => TextFormField(
        controller: authController.confirmPasswordFieldController,
        obscureText: !authController.passwordVisible.value,
        decoration: InputDecoration(
          hintText: "Re-enter your password",
          labelText: "Confirm Password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              authController.passwordVisible.isTrue
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              authController.passwordVisible.value =
                  !authController.passwordVisible.value;
            },
          ),
        ),
        validator: (value) {
          if (authController.confirmPasswordFieldController.text.isEmpty) {
            return kPassNullError;
          } else if (authController.confirmPasswordFieldController.text !=
              authController.passwordFieldController.text) {
            return kMatchPassError;
          } else if (authController.confirmPasswordFieldController.text.length <
              8) {
            return kShortPassError;
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
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

  Widget buildPasswordFormField() {
    return Obx(() => TextFormField(
          controller: authController.passwordFieldController,
          obscureText: !authController.passwordVisible.value,
          decoration: InputDecoration(
            hintText: "Enter your password",
            labelText: "Password",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                authController.passwordVisible.isTrue
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.black,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                authController.passwordVisible.value =
                    !authController.passwordVisible.value;
              },
            ),
          ),
          validator: (value) {
            if (authController.passwordFieldController.text.isEmpty) {
              return kPassNullError;
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ));
  }

  Future<void> signUpButtonCallback(BuildContext context) async {
    if (_formSingupKey.currentState!.validate()) {
      String snackbarMessage = "";
      try {
        var register = authController.register();
        await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              register,
              message: Text("Creating account"),
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
