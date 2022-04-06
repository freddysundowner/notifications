import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/room_images_model.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/services/local_files_access_service.dart';
import 'package:fluttergistshop/utils/button.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ionicons/ionicons.dart';

final RoomController _homeController = Get.find<RoomController>();

Future<dynamic> showRoomTypeBottomSheet(BuildContext context) {
  _homeController.roomPickedImages.value = [];
  _homeController.roomHosts.value = [];
  _homeController.roomHosts.add(Get.find<AuthController>().usermodel.value!);


  return showModalBottomSheet(
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
        return DraggableScrollableSheet(
            initialChildSize: 0.6,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      color: Theme.of(context).primaryColor,
                      height: 0.01.sh,
                      width: 0.15.sw,
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            showAddTitleDialog(context);
                          },
                          child: Text(
                            "+  Add Title",
                            style:
                                TextStyle(color: Colors.red, fontSize: 16.sp),
                          ),
                        )),
                    SizedBox(
                      height: 0.03.sh,
                    ),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              _homeController.newRoomType.value = "public";
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: _homeController
                                                      .newRoomType.value ==
                                                  "public"
                                              ? Theme.of(context).primaryColor
                                              : Colors.black38,
                                          width: _homeController
                                                      .newRoomType.value ==
                                                  "public"
                                              ? 5
                                              : 1),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Ionicons.earth,
                                      color: Theme.of(context).primaryColor,
                                      size: 80,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 0.01.sh,
                                ),
                                Text(
                                  "Public Room",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 18.sp),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _homeController.newRoomType.value = "private";
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: _homeController
                                                      .newRoomType.value ==
                                                  "private"
                                              ? Theme.of(context).primaryColor
                                              : Colors.black38,
                                          width: _homeController
                                                      .newRoomType.value ==
                                                  "private"
                                              ? 5
                                              : 1),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Ionicons.shield_checkmark_outline,
                                      color: Theme.of(context).primaryColor,
                                      size: 80,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 0.01.sh,
                                ),
                                Text(
                                  "Private Room",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 18.sp),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    }),
                    SizedBox(
                      height: 0.04.sh,
                    ),
                    Obx(() {
                      return InkWell(
                          onTap: () async {
                            if (_homeController.newRoomType.value ==
                                "private") {
                              showAddCoHostBottomSheet(context, private: true);
                              _homeController.fetchAllUsers();
                            } else {
                              showProductBottomSheet(context);
                              await _homeController.fetchUserProducts();
                            }
                          },
                          child: Container(
                            width: 0.8.sw,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context).primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  _homeController.newRoomType.value == "private"
                                      ? "Pick friends to chat with"
                                      : "Proceed",
                                  style: TextStyle(
                                      fontSize: 18.sp, color: Colors.white),
                                ),
                              ),
                            ),
                          ));
                    })
                  ],
                ),
              );
            });
      });
    },
  );
}

Future<dynamic> showAddTitleDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Add a title for your room",
            style: TextStyle(color: Colors.black, fontSize: 16.sp),
          ),
          children: [
            TextField(
              controller: _homeController.roomTitleController,
              autofocus: true,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Enter room title",
              ),
              style: TextStyle(color: Colors.black, fontSize: 12.sp),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(
                    width: 0.03.sw,
                  ),
                  InkWell(
                    onTap: () {
                      Get.closeAllSnackbars();
                      Get.back();
                    },
                    child: Text(
                      "Okay".toUpperCase(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      });
}

Future<dynamic> showProductBottomSheet(BuildContext context) async {
  return showModalBottomSheet(
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
        return DraggableScrollableSheet(
            initialChildSize: 0.5,
            expand: false,
            builder: (BuildContext productContext,
                ScrollController scrollController) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      color: Theme.of(productContext).primaryColor,
                      height: 0.01.sh,
                      width: 0.15.sw,
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Text(
                      "Choose product",
                      style: TextStyle(color: Colors.black87, fontSize: 16.sp),
                    ),
                    SizedBox(
                      height: 0.01.sh,
                    ),
                    Obx(() {
                      return _homeController.userProductsLoading.isFalse
                          ? SizedBox(
                              height: 0.35.sh,
                              child: _homeController.userProducts.isNotEmpty
                                  ? GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      // physics: ScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemCount:
                                          _homeController.userProducts.length,
                                      itemBuilder: (context, index) {
                                        Product product = Product.fromJson(
                                            _homeController.userProducts
                                                .elementAt(index));

                                        return InkWell(
                                          onTap: () {
                                            Get.back();
                                            _homeController.roomPickedProduct
                                                .value = product;

                                            showChooseImagesBottomSheet(
                                                context, product);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Center(
                                                    child: product
                                                            .images!.isNotEmpty
                                                        ? CachedNetworkImage(
                                                            imageUrl: product
                                                                .images!.first,
                                                            height: 0.1.sh,
                                                            width: 0.2.sw,
                                                            fit: BoxFit.fill,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CircularProgressIndicator(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          )
                                                        : Image.asset(
                                                            "assets/icons/no_image.png",
                                                            height: 0.1.sh,
                                                            width: 0.2.sw,
                                                            fit: BoxFit.fill,
                                                          ),
                                                  ),
                                                ),
                                                Center(
                                                    child: Text(
                                                  product.name!,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12.sp),
                                                ))
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : Text(
                                      "You have no products yet",
                                      style: TextStyle(
                                          fontSize: 16.sp, color: Colors.grey),
                                    ))
                          : const CircularProgressIndicator(
                              color: Colors.black,
                            );
                    }),
                  ],
                ),
              );
            });
      });
    },
  );
}

Future<dynamic> showChooseImagesBottomSheet(
    BuildContext context, Product product) {
  generateProductImages(product);

  return showModalBottomSheet(
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
        return DraggableScrollableSheet(
            initialChildSize: 0.8,
            expand: false,
            builder: (BuildContext productContext,
                ScrollController scrollController) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      color: Theme.of(productContext).primaryColor,
                      height: 0.01.sh,
                      width: 0.15.sw,
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    InkWell(
                      onTap: () {
                        showAddCoHostBottomSheet(context);
                        _homeController.fetchAllUsers();
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.people,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 0.01.sw,
                          ),
                          Text(
                            "Add a Co-host",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Text(
                      "${product.name} images",
                      style: TextStyle(color: Colors.black87, fontSize: 16.sp),
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    SizedBox(
                      height: 0.35.sh,
                      child: Obx(() {
                        return GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // physics: ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.99,
                            ),
                            itemCount: _homeController.roomPickedImages.length,
                            itemBuilder: (context, index) {
                              RoomImagesModel roomImages = _homeController
                                  .roomPickedImages
                                  .elementAt(index);
                              return InkWell(
                                onTap: () {
                                  pickImage(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: roomImages.isReal
                                            ? CachedNetworkImage(
                                                imageUrl: roomImages.imageUrl,
                                                height: 0.1.sh,
                                                width: 0.2.sw,
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )
                                            : roomImages.isPath
                                                ? Image.file(
                                                    File(roomImages.imageUrl),
                                                    height: 0.1.sh,
                                                    width: 0.2.sw,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Image.asset(
                                                    roomImages.imageUrl,
                                                    height: 0.1.sh,
                                                    width: 0.2.sw,
                                                    fit: BoxFit.fill,
                                                  ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }),
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 0.05.sh,
                          width: 0.3.sw,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 0.1,
                                  blurRadius: 0.5,
                                  offset: Offset(
                                      0, 5), // changes position of shadow
                                ),
                              ]),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icons/wallet_icon.png",
                                color: Colors.grey,
                                width: 0.1.sw,
                                height: 0.03.sh,
                              ),
                              SizedBox(
                                height: 0.04.sh,
                                child: const VerticalDivider(
                                  width: 0.001,
                                ),
                              ),
                              SizedBox(
                                width: 0.03.sw,
                              ),
                              Text(
                                product.price.toString(),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.03.sh,
                    ),
                    InkWell(
                        onTap: () {
                          Get.back();
                          Get.back();
                          _homeController.createRoom();
                        },
                        child: Button(text: "Finish", width: 0.9.sw))
                  ],
                ),
              );
            });
      });
    },
  );
}

Future<dynamic> showAddCoHostBottomSheet(BuildContext context,
    {bool? private = false}) {
  return showModalBottomSheet(
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
        return DraggableScrollableSheet(
            initialChildSize: 0.8,
            expand: false,
            builder: (BuildContext productContext,
                ScrollController scrollController) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // Container(
                    //   color: Theme.of(productContext).primaryColor,
                    //   height: 0.01.sh,
                    //   width: 0.15.sw,
                    // ),
                    SizedBox(
                      height: 0.01.sh,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add Co-hosts",
                          style: TextStyle(color: Colors.black87, fontSize: 16.sp),
                        ),
                        IconButton(
                            onPressed: () async {
                              Get.back();
                              if (private != null && private == true && _homeController.roomHosts.length > 1) {
                                showProductBottomSheet(context);
                                await _homeController.fetchUserProducts();
                              }

                            },
                            icon: const Icon(Icons.done))
                      ],
                    ),
                    SizedBox(
                      height: 0.01.sh,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                        height: 0.07.sh,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            const Icon(
                              Ionicons.search,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 0.03.sw,
                            ),
                            Expanded(
                              child: Center(
                                child: TextField(
                                  controller:
                                  _homeController.searchUsersController,
                                  autofocus: false,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.visiblePassword,
                                  onChanged: (text) =>
                                      _homeController.searchUsers(),
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.sp,
                                        decoration: TextDecoration.none),
                                    border: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.01.sh,
                    ),
                    Obx(() {
                      return _homeController.allUsersLoading.isFalse
                          ? SizedBox(
                              height: 0.55.sh,
                              child: _homeController.searchedUsers.isNotEmpty
                                  ? GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      // physics: ScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.9,
                                      ),
                                      itemCount:
                                          _homeController.searchedUsers.length,
                                      itemBuilder: (context, index) {
                                        UserModel user = UserModel.fromJson(
                                            _homeController.searchedUsers
                                                .elementAt(index));
                                        return InkWell(
                                          onTap: () {
                                            if (_homeController.roomHosts
                                                .contains(user)) {
                                              _homeController.roomHosts
                                                  .remove(user);
                                            } else {
                                              _homeController.roomHosts
                                                  .add(user);

                                              printOut("adding hosts ${_homeController.roomHosts.length}");
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Obx(() {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: user.profilePhoto ==
                                                            "" || user.profilePhoto == null
                                                        ? CircleAvatar(
                                                            radius: 35,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            foregroundImage:
                                                                _homeController
                                                                        .roomHosts
                                                                        .contains(
                                                                            user)
                                                                    ? const AssetImage(
                                                                        "assets/icons/picked.png")
                                                                    : null,
                                                            backgroundImage:
                                                                const AssetImage(
                                                                    "assets/icons/profile_placeholder.png"))
                                                        : CircleAvatar(
                                                            radius: 35,
                                                            onBackgroundImageError:
                                                                (object,
                                                                        stackTrace) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                            backgroundColor:
                                                                Colors.black38,
                                                            foregroundImage: _homeController
                                                                    .roomHosts
                                                                    .contains(
                                                                        user)
                                                                ? const AssetImage(
                                                                    "assets/icons/picked.png")
                                                                : null,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    imageUrl +
                                                                        user.profilePhoto!),
                                                          ),
                                                  ),
                                                );
                                              }),
                                              Text(
                                                user.userName.toString().length > 5 ? "${user.userName}".substring(0, 5) + "..." : "${user.userName}",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16.sp),
                                              )
                                            ],
                                          ),
                                        );
                                      })
                                  : const Text("No users to add"))
                          : const CircularProgressIndicator();
                    }),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    // InkWell(
                    //     onTap: () async {
                    //       Get.back();
                    //       if (private != null && private == true && _homeController.roomHosts.length > 1) {
                    //         showProductBottomSheet(context);
                    //         await _homeController.fetchUserProducts();
                    //       }
                    //     },
                    //     child: Button(text: "Continue", width: 0.9.sw))
                  ],
                ),
              );
            });
      });
    },
  );
}

generateProductImages(Product product) {
  for (var i = 0; i < product.images!.length; i++) {
    _homeController.roomPickedImages
        .add(RoomImagesModel(product.images!.elementAt(i), true, false));
  }

  do {
    _homeController.roomPickedImages
        .add(RoomImagesModel("assets/icons/no_image.png", false, false));
  } while (_homeController.roomPickedImages.length < 6);
}

pickImage(BuildContext context) async {
  String path = await choseImageFromLocalFiles(context,
      aspectration: const CropAspectRatio(ratioX: 3, ratioY: 2));

  printOut("Path to picked image $path");

  _homeController.roomPickedImages.insert(
      _homeController.roomPickedImages.indexWhere(
          (element) => element.isReal == false && element.isPath == false),
      RoomImagesModel(path, false, true));
  if (path == null) {
    throw LocalImagePickingUnknownReasonFailureException();
  }
}
