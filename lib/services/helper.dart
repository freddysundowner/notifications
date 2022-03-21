import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helper {
  String getPathForProductImage(String? id, int index) {
    String path = "products/images/$id";
    return path + "_$index";
  }

  Widget sizedContainer(Widget child, width, height) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(child: child),
    );
  }

  static debug(
    data, {
    bool show = true,
  }) {
    if (show) print(data);
  }

  static showSnackBack(BuildContext context, String message,
      {Color? color = Colors.green}) {

    GetSnackBar(message: message,);
  }
}
