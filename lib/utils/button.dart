import 'package:flutter/material.dart';
import 'package:fluttergistshop/utils/styles.dart';

class Button extends StatelessWidget {
  final String text;
  final dynamic width;
  Button({Key? key, required this.text, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: primarycolor),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
