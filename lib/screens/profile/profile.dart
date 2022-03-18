import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/screens/products/my_products.dart';
import 'package:fluttergistshop/screens/profile/change_display_picture_screen.dart';
import 'package:fluttergistshop/screens/profile/settings_page.dart';
import 'package:fluttergistshop/screens/shops/shop_view.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:fluttergistshop/widgets/product_card.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  AuthController authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();


  Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(() {
              return _userController.profileLoading.isFalse && _userController.currentProfile.value.id == authController.currentuser!.id ?
                InkWell(
                onTap: () {
                  if (authController.currentuser!.shopId != null &&
                      authController.currentuser!.shopId!.id != "") {
                    Get.to(() => ShopView(authController.currentuser!.shopId!));
                  }
                },
                child: const Icon(
                  Icons.shopping_basket,
                  color: primarycolor,
                  size: 30,
                ),
              ): Container();
            }
          ),
          SizedBox(
            width: 15.w,
          ),
          Obx(() {
              return _userController.profileLoading.isFalse && _userController.currentProfile.value.id == authController.currentuser!.id ?InkWell(
                onTap: () {
                 // authController.signOut();
                  Get.to(SettingsPage());
                },
                child: const Icon(
                  Icons.settings,
                  color: primarycolor,
                  size: 30,
                ),
              ) : Container();
            }
          ),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            UserModel profile = _userController.currentProfile.value;
              return _userController.profileLoading.isFalse ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        if (profile.id == authController.currentuser!.id) {
                          Get.to(() => ChageProfileImage());
                        }
                      },
                      child: CachedNetworkImage(
                        imageUrl: profile.profilePhoto!,
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
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          size: 120,
                        ),
                      )),
                  Text(
                    profile.firstName! +
                        " " +
                        profile.lastName!,
                    style: TextStyle(fontSize: 18.sp, color: Colors.black),
                  ),
                  Text(
                    "@${profile.userName!}",
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
                            profile.following != null ? profile.following!.length.toString() : "0",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: primarycolor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 0.01.sw,
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
                        width: 0.1.sw,
                      ),
                      Row(
                        children: [
                          Text(
                            profile.followers != null ? profile.followers!.length.toString() : "0",
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: primarycolor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 0.01.sw,
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
                    height: 0.03.sh,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.bio!,
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.03.sh,
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
                                  "${profile.firstName} Products",
                              edit: false),
                        ),
                        child: Text("View all",
                            style: TextStyle(fontSize: 13.sp, color: primarycolor)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 0.02.sh,
                  ),
                  GetX<ProductController>(
                      initState: (_) async =>
                          Get.find<ProductController>().products =
                              await ProductController.getProductsByShop(
                                  profile.shopId!.id),
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
              ) : SizedBox(
                height: 0.5.sh,
                  child: const Center(child: CircularProgressIndicator()));
            }
          ),
        ),
      ),
    );
  }
}
