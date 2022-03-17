import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/shop_controller.dart';
import 'package:get/get.dart';

class SearchField extends StatelessWidget {
  final onSubmit;
  final textController;
  final ShopController _shopController = Get.find<ShopController>();
  SearchField({
    Key? key,
    this.onSubmit, this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: textController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: "Search Shops",
          prefixIcon: const Icon(Icons.search),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.sm, vertical: 9.sm),
        ),
        onChanged: (c) => onSubmit,
      ),
    );
  }
}
