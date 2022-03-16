import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/edit_product/components/edit_product_form.dart';
import 'package:fluttergistshop/utils/constants.dart';

class EditProductScreen extends StatelessWidget {
  final Product? product;
  const EditProductScreen({Key? key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    "Product Details",
                    style: headingStyle,
                  ),
                  SizedBox(height: 30.h),
                  EditProductForm(product: product),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
