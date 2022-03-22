import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:fluttergistshop/widgets/product_card.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  AuthController authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();
  final _nameFormKey = GlobalKey<FormState>();
  final _bioFormKey = GlobalKey<FormState>();
  var nameError = "";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(() {
            return _userController.profileLoading.isFalse &&
                    _userController.currentProfile.value.id ==
                        authController.currentuser!.id
                ? InkWell(
                    onTap: () {
                      if (authController.currentuser!.shopId != null &&
                          authController.currentuser!.shopId!.id != "") {
                        Get.to(() =>
                            ShopView(authController.currentuser!.shopId!));
                      }
                    },
                    child: const Icon(
                      Icons.shopping_basket,
                      color: primarycolor,
                      size: 30,
                    ),
                  )
                : Container();
          }),
          SizedBox(
            width: 15.w,
          ),
          Obx(() {
            return _userController.profileLoading.isFalse &&
                    _userController.currentProfile.value.id ==
                        authController.currentuser!.id
                ? InkWell(
                    onTap: () {
                      Get.to(SettingsPage());
                    },
                    child: const Icon(
                      Icons.settings,
                      color: primarycolor,
                      size: 30,
                    ),
                  )
                : Container();
          }),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                UserModel profile = _userController.currentProfile.value;
                return _userController.profileLoading.isFalse
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                if (profile.id ==
                                    authController.currentuser!.id) {
                                  Get.to(() => ChageProfileImage());
                                }
                              },
                              child: CachedNetworkImage(
                                imageUrl: profile.profilePhoto!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  size: 120,
                                ),
                              )),
                          InkWell(
                            onTap: () => updateName(context),
                            child: Text(
                              profile.firstName! + " " + profile.lastName!,
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.black),
                            ),
                          ),
                          Text(
                            "@${profile.userName!}",
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.black),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    profile.following != null
                                        ? profile.following!.length.toString()
                                        : "0",
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
                                    profile.followers != null
                                        ? profile.followers!.length.toString()
                                        : "0",
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
                          InkWell(
                            onTap: () => updateBio(context),
                            child: Text(
                              profile.bio!,
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          SizedBox(
                            height: 0.03.sh,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Products",
                                  style: TextStyle(
                                      fontSize: 13.sp, color: primarycolor)),
                              InkWell(
                                onTap: () => Get.to(
                                  () => MyProducts(
                                      title: "${profile.firstName} Products",
                                      edit: false),
                                ),
                                child: Text("View all",
                                    style: TextStyle(
                                        fontSize: 13.sp, color: primarycolor)),
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
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
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
                                                  builder: (context) =>
                                                      FullProduct(
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
                      )
                    : SizedBox(
                        height: 0.5.sh,
                        child:
                            const Center(child: CircularProgressIndicator()));
              }),
            ),
          ],
        ),
      ),
    );
  }

  updateName(BuildContext context) {
    firstNameController.text = authController.usermodel.value!.firstName!;
    lastNameController.text = authController.usermodel.value!.lastName!;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      )),
      builder: (context) {
        UserModel user = authController.usermodel.value!;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back_ios,
                            size: 20, color: Colors.black),
                      ),
                      Center(
                          child: Text(
                        "Update your name",
                        style: TextStyle(fontSize: 20.sp, color: Colors.black),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Form(
                          key: _nameFormKey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 0.45.sw,
                                height: 0.2.sh,
                                child: TextFormField(
                                  controller: firstNameController,
                                  autocorrect: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: 'First name',
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                    errorText: "",
                                  ),
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 0.45.sw,
                                height: 0.2.sh,
                                child: TextFormField(
                                  controller: lastNameController,
                                  autocorrect: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: 'Last name',
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                    errorText: "",
                                  ),
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.04.sh,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_nameFormKey.currentState!.validate()) {
                        printOut("Validated");

                        Get.back();

                        await UserAPI().updateUser({
                          "firstName": firstNameController.text,
                          "lastName": lastNameController.text,
                        }, FirebaseAuth.instance.currentUser!.uid);

                        authController.usermodel.value!.firstName =
                            firstNameController.text;
                        authController.usermodel.value!.lastName =
                            lastNameController.text;

                        _userController.currentProfile.value.firstName =
                            firstNameController.text;
                        _userController.currentProfile.value.lastName =
                            lastNameController.text;

                        _userController.currentProfile.refresh();

                      } else {
                        printOut("Failed Validating");
                      }
                    },
                    child: Container(
                      height: 0.08.sh,
                      width: 0.8.sw,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  updateBio(BuildContext context) {
    bioController.text = authController.usermodel.value!.bio!;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      )),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back_ios,
                            size: 20, color: Colors.black),
                      ),
                      Center(
                          child: Text(
                        "Update your bio",
                        style: TextStyle(fontSize: 20.sp, color: Colors.black),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Form(
                          key: _bioFormKey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 0.9.sw,
                                height: 0.2.sh,
                                child: TextFormField(
                                  controller: bioController,
                                  autocorrect: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: 'Describe yourself',
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.04.sh,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_bioFormKey.currentState!.validate()) {
                        printOut("Validated");


                        Get.back();

                        await UserAPI().updateUser({"bio": bioController.text},
                            FirebaseAuth.instance.currentUser!.uid);

                        authController.usermodel.value!.bio =
                            bioController.text;
                        _userController.currentProfile.value.bio =
                            bioController.text;
                        _userController.currentProfile.refresh();

                      } else {
                        printOut("Failed Validating");
                      }
                    },
                    child: Container(
                      height: 0.08.sh,
                      width: 0.8.sw,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
