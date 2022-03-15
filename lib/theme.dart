import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttergistshop/utils/utils.dart';

ThemeData theme() {
  return ThemeData(
    backgroundColor: Colors.grey[50],
    bottomAppBarColor: Colors.grey[50],
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Muli",
    primarySwatch: primarycolor,
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black,
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return const TextTheme(
    bodyText1: TextStyle(
      color: kTextColor,
      fontSize: 16,
    ),
    bodyText2: TextStyle(
      color: kTextColor,
      fontSize: 14,
    ),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    iconTheme: IconThemeData(color: Colors.black),
    toolbarTextStyle: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    titleTextStyle: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    centerTitle: true,
  );
}
