import 'package:flutter/material.dart';

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
}
