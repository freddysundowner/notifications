import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/widgets/widgets.dart';
import 'package:ionicons/ionicons.dart';
import '../../utils/utils.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _formForgotPasswordKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  @override
  void dispose() {
    emailFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    "Forgot Password",
                    style: headingStyle,
                  ),
                  Text(
                    "Please enter your email and we will send \nyou a link to reset password",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Form(
                    key: _formForgotPasswordKey,
                    child: Column(
                      children: [
                        buildEmailFormField(),
                        SizedBox(height: 30.h),
                        SizedBox(height: 20.h),
                        DefaultButton(
                          text: "Send verification email",
                          press: () {},
                        ),
                        SizedBox(height: 20.h),
                        NoAccountText(),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
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
        if (value!.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
