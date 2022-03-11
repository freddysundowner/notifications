import 'package:flutter/material.dart';
import 'package:fluttergistshop/utils/styles.dart';

class Button extends StatelessWidget {
  final String text;
  Button({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: primarycolor),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
