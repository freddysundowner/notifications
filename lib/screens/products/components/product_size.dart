import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';

class ProductSize extends StatelessWidget {
  final List productSizes;
  final Function(String) onSelected;
  CheckOutController checkOutController = Get.find<CheckOutController>();
  ProductSize({required this.productSizes, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
      ),
      child: Row(
        children: [
          for (var i = 0; i < productSizes.length; i++)
            GestureDetector(
              onTap: () {
                onSelected("${productSizes[i]}");
                checkOutController.selectetedvariation.value = i;
              },
              child: Obx(() => Container(
                    width: 42.0.sm,
                    height: 42.0.sm,
                    decoration: BoxDecoration(
                      color: checkOutController.selectetedvariation == i
                          ? primarycolor
                          : Color(0xFFDCDCDC),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ),
                    child: Text(
                      "${productSizes[i]}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: checkOutController.selectetedvariation == i
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16.0.sp,
                      ),
                    ),
                  )),
            )
        ],
      ),
    );
  }
}
