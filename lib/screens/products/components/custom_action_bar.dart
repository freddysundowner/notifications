import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/utils/constants.dart';

import '../../../utils/utils.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final String qty;
  CustomActionBar({
    required this.title,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.white,
          Colors.white.withOpacity(0),
        ],
        begin: Alignment(0, 0),
        end: Alignment(0, 1),
      )),
      padding: EdgeInsets.only(
        top: 56.0.sm,
        left: 24.0.sm,
        right: 24.0.sm,
        bottom: 42.0.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 42.0.w,
              height: 42.0.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: Image(
                image: AssetImage("assets/images/back_arrow.png"),
                color: Colors.white,
                width: 16.0,
                height: 16.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.sm),
              height: 42.0.sm,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: Text(
                "qty: $qty",
                style: TextStyle(
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
