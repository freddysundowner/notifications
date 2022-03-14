import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:fluttergistshop/widgets/default_button.dart';
import 'package:get/get.dart';

class CheckOutCard extends StatelessWidget {
  final CheckOutController checkOutController = Get.find<CheckOutController>();
  final VoidCallback onCheckoutPressed;
  CheckOutCard({
    Key? key,
    required this.onCheckoutPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFDADADA).withOpacity(0.6),
            offset: Offset(0, -15),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(text: "Tax\n", children: [
                        TextSpan(
                          text: currencySymbol +
                              "" +
                              checkOutController.tax.value.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]),
                    ),
                    Text.rich(
                      TextSpan(text: "Shipping Cost \n", children: [
                        TextSpan(
                          text: currencySymbol +
                              "" +
                              checkOutController.shipping.value.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]),
                    ),
                    Text.rich(
                      TextSpan(text: "Total\n", children: [
                        TextSpan(
                          text: currencySymbol +
                              "" +
                              checkOutController.ordertotal.value.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: DefaultButton(
                    color: primarycolor,
                    text: "Checkout",
                    press: onCheckoutPressed,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
