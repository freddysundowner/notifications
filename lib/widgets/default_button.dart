import 'package:flutter/material.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color;
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = primarycolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => press(),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15.sp,
            color: color,
          ),
        ),
      ),
    );
  }
}
