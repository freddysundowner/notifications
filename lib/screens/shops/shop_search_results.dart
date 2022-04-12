import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/global.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/shop_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/models/shop.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/screens/profile/profile.dart';
import 'package:fluttergistshop/screens/shops/shop_view.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:get/get.dart';

class ShopSearchResults extends StatelessWidget {
  final ShopController _shopController = Get.find<ShopController>();
  final UserController _userController = Get.find<UserController>();

  final GlobalController _globalController = Get.find<GlobalController>();
  Future<void> refreshPage() {
    return Future<void>.value();
  }

  List<String> searchOptions = ["Shop", "Users", "Products", "Rooms"];
  List<Product> products = getProducts();
// Create a variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.3.sm),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.sm),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _globalController.searchShopController,
                            textInputAction: TextInputAction.search,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: "Search...",
                              prefixIcon: const Icon(Icons.search),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.sm, vertical: 9.sm),
                            ),
                            onChanged: (c) {
                              if (c.isNotEmpty) {
                                // _globalController.searchShopController.text = c;
                                _globalController.searchresults.value = [];
                                _search(
                                    _globalController.currentsearchtab.value);
                              } else {
                                print("is empty");
                                _globalController.searchresults.value = [];
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _globalController.searchShopController.text = "";
                        Get.back();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
              Obx(() {
                return Column(
                  children: [
                    if (_globalController.isSearching.isTrue)
                      Transform.scale(
                          scale: 0.3,
                          child: const CircularProgressIndicator(
                            color: Colors.black,
                          )),
                    _searchTabs(),
                  ],
                );
              }),
              Expanded(
                child: Obx(() {
                  if (_globalController.searchresults.isEmpty &&
                      _globalController.searchShopController.text.isNotEmpty) {
                    return Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text("No results"));
                  }
                  if (_globalController.searchresults.isNotEmpty &&
                      _globalController.isSearching.isFalse) {
                    return ListView.builder(
                      controller: _globalController.scrollcontroller,
                      itemBuilder: (_, i) {
                        var e = _globalController.searchresults.elementAt(i);

                        if (_globalController.currentsearchtab.value == 0) {
                          return _singleItemShop(Shop.fromJson(e));
                        }
                        if (_globalController.currentsearchtab.value == 1) {
                          return _singleItemUser(UserModel.fromJson(e));
                        }
                        if (_globalController.currentsearchtab.value == 2) {
                          return _singleItemProduct(Product.fromJson(e));
                        }
                        if (_globalController.currentsearchtab.value == 3) {
                          return _singleItemRoom(RoomModel.fromJson(e));
                        }
                        return Container();
                      },
                      itemCount: _globalController.searchresults.length,
                    );
                  }
                  return Container();
                }),
              )
            ],
          ),
        ),
      ),
      //body: Body(),
    );
  }

  InkWell _singleItemShop(Shop e) {
    return InkWell(
      onTap: () {
        _shopController.currentShop.value = e;
        Get.to(() => ShopView());
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(e.image!),
            ),
            SizedBox(
              width: 0.04.sw,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.name!,
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  ),
                  Text(
                    e.description!,
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell _singleItemUser(UserModel e) {
    return InkWell(
      onTap: () {
        _userController.getUserProfile(e.id!);
        Get.to(() => Profile());
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(e.profilePhoto!),
            ),
            SizedBox(
              width: 0.04.sw,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.firstName! + " " + e.lastName!,
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  ),
                  Text(
                    e.bio!,
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell _singleItemProduct(Product e) {
    return InkWell(
      onTap: () {
        Get.to(FullProduct(
          product: e,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                  e.images!.isNotEmpty ? e.images![0] : imageplaceholder),
            ),
            SizedBox(
              width: 0.04.sw,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.name!,
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  ),
                  Text(
                    e.description!,
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell _singleItemRoom(RoomModel e) {
    return InkWell(
      onTap: () {
        Get.find<RoomController>().joinRoom(e.id!);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            e.userIds!.isNotEmpty
                ? CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(e.userIds![0].profilePhoto!))
                : const CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        AssetImage("assets/icons/profile_placeholder.png"),
                  ),
            SizedBox(
              width: 0.04.sw,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title!,
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                  ),
                  Row(
                    children: e.userIds!
                        .map((e) => Text(
                              e.firstName!,
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 14.sp),
                            ))
                        .toList(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _search(int index) {
    _globalController.searchresults.value = [];
    _globalController.currentsearchtab.value = index;
    _globalController.searchoption.value = searchOptions[index].toLowerCase();
    _globalController.search(searchOptions[index].toLowerCase());
  }

  _searchTabs() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              searchOptions.length,
              (index) => Obx(
                    () => InkWell(
                      onTap: () => _search(index),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: _globalController.currentsearchtab.value ==
                                index
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 0.5,
                                      blurRadius: 0.8,
                                      offset: Offset(
                                          0, 5), // changes position of shadow
                                    ),
                                  ])
                            : null,
                        child: Text(
                          searchOptions[index],
                          style: const TextStyle(
                              fontFamily: "Muli", fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ))),
    );
  }
}
