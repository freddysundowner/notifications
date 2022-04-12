import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';

class ProductSize extends StatelessWidget {
  final List productSizes;
  final Function(String) onSelected;
  CheckOutController checkOutController = Get.find<CheckOutController>();
  ProductSize({Key? key, required this.productSizes, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.05.sh,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: productSizes.length,
          itemBuilder: (context, index) {
            var i = index;
            return GestureDetector(
              onTap: () {
                onSelected("${productSizes[i]}");
                checkOutController.selectetedvariation.value = i;
              },
              child: Obx(() => Container(
                    // width: 0.1.sw,
                    height: 0.04.sh,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: checkOutController.selectetedvariation.value == i
                          ? primarycolor
                          : const Color(0xFFDCDCDC),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ),
                    child: Text(
                      "${productSizes[i]}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:
                            checkOutController.selectetedvariation.value == i
                                ? Colors.white
                                : Colors.black,
                        fontSize: 16.0.sp,
                      ),
                    ),
                  )),
            );
          }),
    );
  }
}
