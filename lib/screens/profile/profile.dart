import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/screens/products/my_products.dart';
import 'package:fluttergistshop/screens/shops/shop_view.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:fluttergistshop/widgets/product_card.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  final List<Product> products = getProducts();
  AuthController authController = Get.find<AuthController>();
  Profile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => ShopView());
            },
            child: Icon(
              Icons.shopping_basket,
              color: primarycolor,
              size: 30,
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          Icon(
            Icons.settings,
            color: primarycolor,
            size: 30,
          ),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: CachedNetworkImageProvider(
                              "https://i.imgur.com/BoN9kdC.png")))),
              Text(
                "Fred Shop",
                style: TextStyle(fontSize: 18.sp, color: Colors.black),
              ),
              Text(
                "@username",
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        "2",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: primarycolor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Following",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: primarycolor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  Row(
                    children: [
                      Text(
                        "2",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: primarycolor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Followers",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: primarycolor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "description here",
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Products",
                      style: TextStyle(fontSize: 13.sp, color: primarycolor)),
                  InkWell(
                    onTap: () => Get.to(
                      () => MyProducts(
                          title:
                              "${authController.currentuser!.firstName} Products",
                          edit: false),
                    ),
                    child: Text("View all",
                        style: TextStyle(fontSize: 13.sp, color: primarycolor)),
                  )
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                  height: 200.h,
                  width: double.infinity,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 30,
                    ),
                    physics: BouncingScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: products[index],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullProduct(
                                product: products[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductsGrid() {
    return Container(
      // padding: EdgeInsets.symmetric(
      //   horizontal: 8,
      //   vertical: 16,
      // ),
      // decoration: BoxDecoration(
      //   color: Color(0xFFF5F6F9),
      //   borderRadius: BorderRadius.circular(15),
      // ),
      height: 300.0.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullProduct(
                    product: products[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
