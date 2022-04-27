import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/shop_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/screens/products/my_products.dart';
import 'package:fluttergistshop/screens/profile/change_display_picture_screen.dart';
import 'package:fluttergistshop/screens/profile/followers_following_page.dart';
import 'package:fluttergistshop/screens/profile/upgrade_account.dart';
import 'package:fluttergistshop/screens/shops/add_edit_shop.dart';
import 'package:fluttergistshop/screens/shops/shop_view.dart';
import 'package:fluttergistshop/services/client.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:fluttergistshop/widgets/async_progress_dialog.dart';
import 'package:fluttergistshop/widgets/default_button.dart';
import 'package:fluttergistshop/widgets/product_card.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  AuthController authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();
  ShopController shopController = Get.find<ShopController>();
  ProductController productController = Get.find<ProductController>();
  final RoomController _homeController = Get.find<RoomController>();
  final _nameFormKey = GlobalKey<FormState>();
  final _bioFormKey = GlobalKey<FormState>();
  var nameError = "";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _homeController.onChatPage.value = false;
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
                        shopController.currentShop.value =
                            authController.currentuser!.shopId!;
                        Get.to(() => ShopView());
                      } else {
                        Get.to(() => NewShop());
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
                if (_userController.profileLoading.isFalse) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () async {
                              if (profile.id ==
                                  FirebaseAuth.instance.currentUser!.uid) {
                                Get.to(() => ChageProfileImage());
                                await UserAPI.getUserById();
                                DefaultCacheManager manager =  DefaultCacheManager();
                                manager.emptyCache(); //clears all data in cache.
                              }
                            },
                            child: profile.profilePhoto != null
                                ? Obx(() {
                                    return CachedNetworkImage(
                                        imageUrl: _userController.currentProfile.value.profilePhoto!,
                                        imageBuilder: (context, imageProvider) =>
                                            Container(
                                          width: 0.25.sw,
                                          height: 0.14.sh,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                "assets/icons/profile_placeholder.png",
                                                width: 0.25.sw,
                                                height: 0.14.sh),
                                      );
                                  }
                                )
                                : CircleAvatar(
                                    radius: 50,
                                    child: Image.asset(
                                        "assets/icons/profile_placeholder.png",
                                        width: 0.25.sw,
                                        height: 0.14.sh),
                                  )),
                        InkWell(
                          onTap: () {
                            if (profile.id ==
                                FirebaseAuth.instance.currentUser!.uid) {
                              updateName(context);
                            }
                          },
                          child: Text(
                            "${profile.firstName} ${profile.lastName}",
                            style:
                                TextStyle(fontSize: 18.sp, color: Colors.black),
                          ),
                        ),
                        Text(
                          "@${profile.userName}",
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.black),
                        ),
                        if (profile.id !=
                            FirebaseAuth.instance.currentUser!.uid)
                          Column(
                            children: [
                              SizedBox(
                                height: 0.03.sh,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (profile.followers.contains(
                                      FirebaseAuth.instance.currentUser!.uid)) {
                                    await unFollowUser(profile);
                                  } else {
                                    await followUser(profile);
                                  }
                                },
                                child: Container(
                                  width: 0.2.sw,
                                  height: 0.04.sh,
                                  decoration: BoxDecoration(
                                    color: profile.followers.contains(
                                            FirebaseAuth
                                                .instance.currentUser!.uid)
                                        ? Colors.grey
                                        : Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      profile.followers.contains(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          ? "UnFollow"
                                          : "Follow",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 0.03.sh,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                _userController.getUserFollowing(profile.id!);
                                Get.to(FollowersFollowingPage("Following"));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    profile.followingCount != null
                                        ? profile.followingCount.toString()
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
                            ),
                            SizedBox(
                              width: 0.1.sw,
                            ),
                            InkWell(
                              onTap: () {
                                _userController.getUserFollowers(profile.id!);
                                Get.to(FollowersFollowingPage("Followers"));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    profile.followersCount != null
                                        ? profile.followersCount.toString()
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
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 0.03.sh,
                        ),
                        InkWell(
                          onTap: () {
                            if (profile.id ==
                                FirebaseAuth.instance.currentUser!.uid) {
                              updateBio(context);
                            }
                          },
                          child: Text(
                            profile.bio == null ? "Add Bio" : profile.bio!,
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                        if (profile.memberShip == 1 && FirebaseAuth
                            .instance.currentUser!.uid != profile.id)
                          InkWell(
                            onTap: () {
                              sendGift(context, "send", gccurrency,
                                  userModel: profile,
                                  onButtonPressed: (type, amount) async {
                                var response = DbBase().databaseRequest(
                                    userSendGift, DbBase().postRequestType,
                                    body: {
                                      "fromuser": FirebaseAuth
                                          .instance.currentUser!.uid,
                                      "touser": profile.id,
                                      "amount": amount
                                    });
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AsyncProgressDialog(
                                      response,
                                      message: Text("Sending gift..."),
                                      onError: (e) {},
                                    );
                                  },
                                );
                                var waitedResponse = jsonDecode(await response);
                                print("waitedResponse $waitedResponse");
                                if (waitedResponse["status"] == false) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        waitedResponse["message"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        waitedResponse["message"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                                Get.back();
                                print(waitedResponse);
                              });
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.wallet_giftcard,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    " -- Gift ${profile.userName}",
                                    style: TextStyle(
                                        color: primarycolor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Obx(() {
                          if (productController.products.isNotEmpty) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Products",
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            color: primarycolor)),
                                    InkWell(
                                      onTap: () => Get.to(
                                        () => MyProducts(
                                            title:
                                                "${profile.firstName} Products",
                                            edit: profile.id ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid),
                                      ),
                                      child: Text("View all",
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              color: primarycolor)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 0.03.sh,
                                ),
                                SizedBox(
                                    height: 0.3.sh,
                                    width: double.infinity,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: 0.1.sh,
                                      ),
                                      physics: const BouncingScrollPhysics(),
                                      itemCount:
                                          productController.products.length,
                                      itemBuilder: (context, index) {
                                        return ProductCard(
                                          product:
                                              productController.products[index],
                                          press: () {
                                            Get.to(FullProduct(
                                              product: productController
                                                  .products[index],
                                            ));
                                          },
                                        );
                                      },
                                    )),
                              ],
                            );
                          }
                          return Container();
                        }),
                        SizedBox(
                          height: 0.03.sh,
                        ),
                        if (profile.id ==
                            FirebaseAuth.instance.currentUser!.uid)
                          Obx(() {
                            return _userController
                                        .currentProfile.value.memberShip ==
                                    0
                                ? Center(
                                    child: InkWell(
                                      onTap: () {
                                        upgradeToPremium(context, userModel);
                                      },
                                      child: Container(
                                        width: 0.7.sw,
                                        height: 0.07.sh,
                                        decoration: BoxDecoration(
                                            color: primarycolor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                spreadRadius: 0.5,
                                                blurRadius: 0.8,
                                                offset: Offset(0,
                                                    5), // changes position of shadow
                                              ),
                                            ]),
                                        child: Center(
                                          child: Text(
                                            "Upgrade account",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.sp),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container();
                          }),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                      height: 0.5.sh,
                      child: const Center(child: CircularProgressIndicator()));
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  static sendGift(BuildContext context, String type, String currency,
      {Function? onButtonPressed, UserModel? userModel}) {
    var amountcontroller = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.9,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    type == "send"
                                        ? "How much GistPoints you want to send to ${userModel!.firstName!}"
                                        : "Deposit  $type",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      controller: amountcontroller,
                                      autofocus: true,
                                      maxLength: null,
                                      maxLines: null,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              signed: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                            fontSize: 20,
                                          ),
                                          prefixIcon: currency == gccurrency
                                              ? Icon(Icons
                                                  .account_balance_wallet_sharp)
                                              : Icon(
                                                  CupertinoIcons.money_dollar),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          fillColor: Colors.white),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  DefaultButton(
                                      text: type == "send" ? "Send" : "Deposit",
                                      press: () {
                                        int amount =
                                            int.parse(amountcontroller.text);
                                        if (amount > 0) {
                                          onButtonPressed!(
                                              type, amountcontroller.text);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Amount has to be greater than 0",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      })
                                ]))
                      ],
                    ),
                  ),
                );
              });
        });

    // showModalBottomSheet(
    //   context: context,
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(15),
    //     topRight: Radius.circular(15),
    //   )),
    //   builder: (context) {
    //     return Container(
    //       child: Padding(
    //         padding: EdgeInsets.only(
    //             bottom: MediaQuery.of(context).viewInsets.bottom),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             InkWell(
    //               onTap: () {
    //                 Get.back();
    //               },
    //               child: Padding(
    //                 padding: MediaQuery.of(context).viewInsets,
    //                 child: Icon(Icons.clear, size: 30, color: Colors.white),
    //               ),
    //             ),
    //             Spacer(),
    //             Container(
    //               padding: EdgeInsets.symmetric(horizontal: 20),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text(
    //                     type == "send"
    //                         ? "How much ${currency == gccurrency ? "GistPoints" : "Money"} you want to send to ${userModel!.firstName!}"
    //                         : "Deposit  $type",
    //                     style: TextStyle(fontSize: 21),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Container(
    //                     decoration: new BoxDecoration(
    //                         shape: BoxShape.rectangle,
    //                         color: Colors.white,
    //                         borderRadius: BorderRadius.circular(10)),
    //                     padding: EdgeInsets.symmetric(horizontal: 10),
    //                     child: TextFormField(
    //                       controller: amountcontroller,
    //                       maxLength: null,
    //                       maxLines: null,
    //                       keyboardType: TextInputType.number,
    //                       decoration: InputDecoration(
    //                           hintStyle: TextStyle(
    //                             fontSize: 20,
    //                           ),
    //                           prefixIcon: currency == gccurrency
    //                               ? Icon(Icons.account_balance_wallet_sharp)
    //                               : Icon(CupertinoIcons.money_dollar),
    //                           border: InputBorder.none,
    //                           focusedBorder: InputBorder.none,
    //                           enabledBorder: InputBorder.none,
    //                           errorBorder: InputBorder.none,
    //                           disabledBorder: InputBorder.none,
    //                           fillColor: Colors.white),
    //                       style: TextStyle(
    //                         fontSize: 20,
    //                         color: Colors.black,
    //                         fontWeight: FontWeight.w400,
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   DefaultButton(
    //                       text: type == "send" ? "Send" : "Deposit",
    //                       press: () {
    //                         // int amount = int.parse(amountcontroller.text);
    //                         // if (amount > 0) {
    //                         //   onButtonPressed(type, amountcontroller.text);
    //                         // } else {
    //                         //   topTrayPopup(
    //                         //       "Amount has to be greater than 0");
    //                         // }
    //                       })
    //                 ],
    //               ),
    //             ),
    //             Spacer(),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  Future<void> followUser(UserModel profile) async {
    _userController.currentProfile.value.followers
        .add(FirebaseAuth.instance.currentUser!.uid);
    _userController.currentProfile.value.followersCount =
        _userController.currentProfile.value.followersCount! + 1;

    if (_userController.currentProfile.value.id ==
        authController.currentuser!.id) {
      _userController.currentProfile.value.followingCount =
          _userController.currentProfile.value.followingCount! + 1;
    }
    _userController.currentProfile.refresh();

    await UserAPI()
        .followAUser(FirebaseAuth.instance.currentUser!.uid, profile.id!);
  }

  Future<void> unFollowUser(UserModel profile) async {
    _userController.currentProfile.value.followers
        .remove(FirebaseAuth.instance.currentUser!.uid);

    _userController.currentProfile.value.followersCount =
        _userController.currentProfile.value.followersCount! - 1;

    if (_userController.currentProfile.value.id ==
        authController.currentuser!.id) {
      _userController.currentProfile.value.followingCount =
          _userController.currentProfile.value.followingCount! - 1;
    }

    _userController.currentProfile.refresh();

    await UserAPI()
        .unFollowAUser(FirebaseAuth.instance.currentUser!.uid, profile.id!);

    if (_homeController.roomHosts
            .indexWhere((element) => element.id == profile.id) !=
        -1) {
      _homeController
          .roomHosts[_homeController.roomHosts
              .indexWhere((element) => element.id == profile.id)]
          .followersCount = _homeController
              .roomHosts[_homeController.roomHosts
                  .indexWhere((element) => element.id == profile.id)]
              .followersCount! -
          1;
    }
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
                                  minLines: 1,
                                  maxLines: 5,  // allow user to enter 5 line in textfield
                                  keyboardType: TextInputType.multiline,
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
                                  minLines: 1,
                                  maxLines: 5,  // allow user to enter 5 line in textfield
                                  keyboardType: TextInputType.multiline,
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
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 3,
                                  textInputAction: TextInputAction.newline,
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
