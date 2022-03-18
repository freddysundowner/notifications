import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const String appName = "GistShop";
const String agoraAppID = "eb2b573198f24c98a285c82094696299";
const String currencySymbol = "GC ";
const String currencyName = "Gistcoins ";
const String imageplaceholder = "assets/images/productavatar.jpeg";
const String userimageplaceholder = "assets/images/userimageplaceholder.jpeg";

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter email";
const String kUsernameNullError = "Please Enter your username";
const String kFnamesNullError = "Please Enter your full names";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";

const String kAddressNullError = "Please Enter your address";
const String FIELD_REQUIRED_MSG = "This field is required";

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);

final headingStyle = TextStyle(
  fontSize: 25.sp,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final boldHeading = TextStyle(
    fontSize: 22.sp, fontWeight: FontWeight.w600, color: Colors.black);

final regularDarkText = TextStyle(
    fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: Colors.black);
