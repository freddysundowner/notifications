import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchField extends StatelessWidget {
  final Function? onSubmit;
  const SearchField({
    Key? key,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: "Search Shops",
          prefixIcon: Icon(Icons.search),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.sm, vertical: 9.sm),
        ),
        onSubmitted: (c) => onSubmit,
      ),
    );
  }
}
