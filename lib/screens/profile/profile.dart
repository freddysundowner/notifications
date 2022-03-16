import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/screens/products/my_products.dart';
import 'package:fluttergistshop/screens/profile/change_display_picture_screen.dart';
import 'package:fluttergistshop/screens/shops/shop_view.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:fluttergistshop/widgets/product_card.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  AuthController authController = Get.find<AuthController>();
  Profile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              if (authController.currentuser!.shopId != null &&
                  authController.currentuser!.shopId != "") {
                Get.to(() => ShopView());
              }
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
          InkWell(
            onTap: () {
              authController.signOut();
            },
            child: Icon(
              Icons.settings,
              color: primarycolor,
              size: 30,
            ),
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
              InkWell(
                  onTap: () {
                    Get.to(() => ChageProfileImage());
                  },
                  child: CachedNetworkImage(
                    imageUrl: authController.currentuser!.profilePhoto!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      size: 120,
                    ),
                  )),
              Text(
                authController.currentuser!.firstName! +
                    " " +
                    authController.currentuser!.lastName!,
                style: TextStyle(fontSize: 18.sp, color: Colors.black),
              ),
              Text(
                "@${authController.currentuser!.userName!}",
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
                    authController.currentuser!.bio!,
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
              GetX<ProductController>(
                  initState: (_) async =>
                      Get.find<ProductController>().products =
                          await ProductController.getProductsByShop(
                              authController.currentuser!.shopId!.id),
                  builder: (_) {
                    print(_.products.length);
                    if (_.products.length == 0) {
                      return Text("No Products yet");
                    }
                    if (_.products.length > 0) {
                      return Container(
                          height: 200.h,
                          width: double.infinity,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) => SizedBox(
                              height: 30,
                            ),
                            physics: BouncingScrollPhysics(),
                            itemCount: _.products.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                product: _.products[index],
                                press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullProduct(
                                        product: _.products[index],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ));
                      // return Column(
                      //   children: _.products.map((e) => Text(e.name)).toList(),
                      // );
                    }
                    return Text("No Products yet");
                  })
            ],
          ),
        ),
      ),
    );
  }
}
