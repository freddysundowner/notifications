import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/utils/styles.dart';

class NothingToShowContainer extends StatelessWidget {
  final String iconPath;
  final String primaryMessage;
  final String secondaryMessage;

  const NothingToShowContainer({
    Key? key,
    this.iconPath = "assets/icons/empty_box.svg",
    this.primaryMessage = "",
    this.secondaryMessage = "",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(height: 16),
          Text(
            "$primaryMessage",
            style: TextStyle(
              color: kTextColor,
              fontSize: 15,
            ),
          ),
          Text(
            "$secondaryMessage",
            style: TextStyle(
              color: kTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
