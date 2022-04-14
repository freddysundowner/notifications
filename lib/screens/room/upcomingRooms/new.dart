import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:fluttergistshop/models/event_model.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/room_images_model.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/screens/profile/profile.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/services/local_files_access_service.dart';
import 'package:fluttergistshop/utils/button.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/widgets/async_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ionicons/ionicons.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';

class NewEventUpcoming extends StatelessWidget {
  EventModel? roomModel;
  NewEventUpcoming({Key? key, this.roomModel}) : super(key: key);
  RoomController homeController = Get.find<RoomController>();
  void toggleSwitch(bool value) {
    if (value == false) {
      homeController.newRoomType.value = "public";
    } else {
      homeController.newRoomType.value = "private";
    }
    homeController.isSwitched.value = value;
  }

  Future<void> _saveEvent(BuildContext context) async {
    if (homeController.eventTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("event title is required"),
        ),
      );
      return;
    }
    if (homeController.roomPickedProduct.value.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("product is required"),
        ),
      );
      return;
    }
    if (homeController.roomHosts.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("add atleast one host"),
        ),
      );
      return;
    }
    if (homeController.eventDate.value?.millisecondsSinceEpoch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Date is required"),
        ),
      );

      return;
    }
    if (homeController.eventDate.value!.difference(DateTime.now()).inMinutes <
        15) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Date must be greater than 15 minutes from now"),
        ),
      );
      return;
    }

    var response;
    String snackbarMessage = "";
    if (roomModel != null) {
      var hosts = [];
      for (var element in homeController.roomHosts) {
        hosts.add(element.id);
      }

      var roomData = {
        "title": homeController.eventTitleController.text,
        "description": homeController.eventDescriptiion.text,
        "roomType": homeController.newRoomType.value,
        "productIds": [homeController.roomPickedProduct.value.id],
        "hostIds": hosts,
        "userIds": [],
        "raisedHands": [],
        "speakerIds": [],
        "event": true,
        "invitedIds": [],
        "shopId": Get.find<AuthController>().usermodel.value!.shopId!.id,
        "status": true,
        "productPrice": homeController.roomPickedProduct.value.price,
        "productImages": homeController.roomPickedProduct.value.images,
        "activeTime": DateTime.now().microsecondsSinceEpoch,
        "eventDate": homeController.eventDate.value!.millisecondsSinceEpoch
      };

      response = homeController.updateEvent(roomModel!.id!, roomData);
    } else {
      print("before event");
      response = homeController.createEvent();
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AsyncProgressDialog(
          response,
          message:
              Text(roomModel != null ? "Updating event" : "Creating event"),
          onError: (e) {
            snackbarMessage = e.toString();
          },
        );
      },
    );

    homeController.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    homeController.roomPickedImages.value = [];
    homeController.roomHosts.value = [];
    homeController.eventTitleController.text = "";
    homeController.eventDate.value = null;
    homeController.roomPickedProduct.value = Product();
    homeController.eventDescriptiion.text = "";
    homeController.newRoomType.value = "";

    if (roomModel == null) {
      homeController.roomHosts.add(Get.find<AuthController>().usermodel.value!);
    } else {
      homeController.eventTitleController.text = roomModel!.title!;
      homeController.eventDescriptiion.text = roomModel!.description!;
      homeController.roomPickedProduct.value = roomModel!.productIds![0];
      homeController.eventDate.value =
          new DateTime.fromMillisecondsSinceEpoch(roomModel!.eventDate!);
      homeController.newRoomType.value = roomModel!.roomType!;
      homeController.roomHosts.value = roomModel!.invitedhostIds!
          .map((e) => UserModel(
              profilePhoto: e.profilePhoto,
              bio: e.bio,
              id: e.id,
              firstName: e.firstName,
              lastName: e.lastName,
              userName: e.userName,
              email: e.email))
          .toList();
    }

    var formatter = new DateFormat('yyyy/MM/dd hh:mm');

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () async {
              _saveEvent(context);
            },
            child: Container(
                margin: EdgeInsets.only(right: 20, top: 15),
                child: Text(
                  roomModel != null ? "Update" : "Save",
                  style: TextStyle(color: Colors.green),
                )),
          )
        ],
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: homeController.eventTitleController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "Event Title",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 13),
                  ),
                  validator: (_) {
                    if (homeController.eventTitleController.text.isEmpty) {
                      return FIELD_REQUIRED_MSG;
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    showAddCoHostBottomSheet(context);
                    homeController.fetchAllUsers();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add Co-Hosts (${homeController.roomHosts.length})",
                          style: TextStyle(fontSize: 13.sm),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (homeController.roomHosts.value.length > 0)
                  ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: homeController.roomHosts
                        .map((element) => InkWell(
                              onTap: () {
                                Get.find<UserController>()
                                    .getUserProfile(element.id!);
                                Get.to(() => Profile());
                              },
                              child: Wrap(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: element.profilePhoto!,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.supervised_user_circle_rounded,
                                      size: 40,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      element.firstName! +
                                          " " +
                                          element.lastName!,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  if (homeController.roomHosts.indexWhere(
                                          (e) => element.id! == e.id!) ==
                                      -1)
                                    InkWell(
                                      onTap: () {
                                        homeController.roomHosts.removeWhere(
                                            (e) => element.id! == e.id);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    showProductBottomSheet(context);
                    await homeController.fetchUserProducts();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          homeController.roomPickedProduct.value.id != null
                              ? "Change ${homeController.roomPickedProduct.value.name}"
                              : "Select Product",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.sm),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
                if (homeController.roomPickedProduct.value.id != null)
                  ListTile(
                    minLeadingWidth: 0,
                    contentPadding: EdgeInsets.all(0),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        homeController
                                .roomPickedProduct.value.images!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: homeController
                                    .roomPickedProduct.value.images!.first,
                                height: 0.1.sh,
                                width: 0.1.sw,
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Image.asset(
                                "assets/icons/no_image.png",
                                height: 0.1.sh,
                                width: 0.2.sw,
                                fit: BoxFit.fill,
                              ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                homeController.roomPickedProduct.value.name!,
                                style: TextStyle(fontSize: 13),
                              ),
                              Text(
                                "GC " +
                                    homeController
                                        .roomPickedProduct.value.price!
                                        .toString(),
                                style: TextStyle(fontSize: 13),
                              ),
                              if (homeController.roomPickedProduct.value
                                  .description!.isNotEmpty)
                                Text(
                                  homeController
                                      .roomPickedProduct.value.description!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 13),
                                ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            homeController.roomPickedProduct.value = Product();
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2020, 5, 5, 20, 50),
                        maxTime: DateTime(2030, 6, 7, 05, 09),
                        onConfirm: (date) {
                      print('confirm $date');
                      homeController.eventDate.value = date;
                      homeController.eventDateController.text = date.toString();
                    }, locale: LocaleType.en);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          homeController.eventDate.value != null
                              ? formatter
                                  .format(homeController.eventDate.value!)
                                  .toString()
                              : "When?",
                          style: TextStyle(fontSize: 16.sm),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Private? ",
                      ),
                      CupertinoSwitch(
                        value: homeController.isSwitched.value,
                        onChanged: toggleSwitch,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: homeController.eventDescriptiion,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "description",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 13),
                  ),
                  validator: (_) {
                    if (homeController.eventTitleController.text.isEmpty) {
                      return FIELD_REQUIRED_MSG;
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                        style:
                            TextStyle(color: Colors.black87, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      Obx(() {
                        return homeController.userProductsLoading.isFalse
                            ? SizedBox(
                                height: 0.35.sh,
                                child: homeController.userProducts.isNotEmpty
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
                                            homeController.userProducts.length,
                                        itemBuilder: (context, index) {
                                          Product product = Product.fromJson(
                                              homeController.userProducts
                                                  .elementAt(index));

                                          return InkWell(
                                            onTap: () {
                                              Get.back();
                                              homeController.roomPickedProduct
                                                  .value = product;

                                              showChooseImagesBottomSheet(
                                                  context, product);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
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
                                                      child: product.images!
                                                              .isNotEmpty
                                                          ? CachedNetworkImage(
                                                              imageUrl: product
                                                                  .images!
                                                                  .first,
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
                                            fontSize: 16.sp,
                                            color: Colors.grey),
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
                      Text(
                        "${product.name} images",
                        style:
                            TextStyle(color: Colors.black87, fontSize: 16.sp),
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
                              itemCount: homeController.roomPickedImages.length,
                              itemBuilder: (context, index) {
                                RoomImagesModel roomImages = homeController
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                                  errorWidget: (context, url,
                                                          error) =>
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
          homeController.friendsToInviteCall();
          return DraggableScrollableSheet(
              initialChildSize: 0.8,
              expand: false,
              builder: (BuildContext productContext,
                  ScrollController scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add Co-hosts",
                            style: TextStyle(
                                color: Colors.black87, fontSize: 16.sp),
                          ),
                          IconButton(
                              onPressed: () async {
                                Get.back();
                                if (private != null &&
                                    private == true &&
                                    homeController.roomHosts.length > 1) {
                                  showProductBottomSheet(context);
                                  await homeController.fetchUserProducts();
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
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
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
                                        homeController.searchUsersController,
                                    autofocus: false,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    keyboardType: TextInputType.visiblePassword,
                                    onChanged: (text) {
                                      print(
                                          "entered ${homeController.friendsToInvite.value.length}");
                                      if (text.isNotEmpty) {
                                        homeController.searchUsersWeAreFriends(
                                            homeController
                                                .searchUsersController.text);
                                      } else {
                                        homeController.friendsToInviteCall();
                                      }
                                    },
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
                        return homeController.allUsersLoading.isFalse
                            ? SizedBox(
                                height: 0.55.sh,
                                child: homeController
                                        .searchedfriendsToInvite.isNotEmpty
                                    ? GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        // physics: ScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 0.9,
                                        ),
                                        itemCount: homeController
                                            .searchedfriendsToInvite.length,
                                        itemBuilder: (context, index) {
                                          UserModel user = UserModel.fromJson(
                                              homeController
                                                  .searchedfriendsToInvite
                                                  .elementAt(index));

                                          return InkWell(
                                            onTap: () {
                                              if (homeController.roomHosts
                                                  .contains(user)) {
                                                homeController.roomHosts
                                                    .remove(user);
                                              } else {
                                                homeController.roomHosts
                                                    .add(user);
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                Obx(() {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: user.profilePhoto ==
                                                                  "" ||
                                                              user.profilePhoto ==
                                                                  null
                                                          ? CircleAvatar(
                                                              radius: 35,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              foregroundImage: homeController
                                                                      .roomHosts
                                                                      .contains(
                                                                          user)
                                                                  ? const AssetImage(
                                                                      "assets/icons/picked.png")
                                                                  : MemoryImage(
                                                                          kTransparentImage)
                                                                      as ImageProvider,
                                                              backgroundImage:
                                                                  const AssetImage(
                                                                      "assets/icons/profile_placeholder.png"))
                                                          : CircleAvatar(
                                                              radius: 35,
                                                              onBackgroundImageError: (object,
                                                                      stackTrace) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                              backgroundColor:
                                                                  Colors
                                                                      .black38,
                                                              foregroundImage: homeController
                                                                      .roomHosts
                                                                      .contains(
                                                                          user)
                                                                  ? const AssetImage(
                                                                      "assets/icons/picked.png")
                                                                  : MemoryImage(
                                                                          kTransparentImage)
                                                                      as ImageProvider,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      imageUrl +
                                                                          user.profilePhoto!),
                                                            ),
                                                    ),
                                                  );
                                                }),
                                                Center(
                                                  child: Text(
                                                    user.firstName! +
                                                        " " +
                                                        user.lastName!,
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 12.sp),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                  ),
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
                      //       if (private != null && private == true && homeController.roomHosts.length > 1) {
                      //         showProductBottomSheet(context);
                      //         await homeController.fetchUserProducts();
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
      homeController.roomPickedImages
          .add(RoomImagesModel(product.images!.elementAt(i), true, false));
    }

    do {
      homeController.roomPickedImages
          .add(RoomImagesModel("assets/icons/no_image.png", false, false));
    } while (homeController.roomPickedImages.length < 6);
  }

  pickImage(BuildContext context) async {
    String path = await choseImageFromLocalFiles(context,
        aspectration: const CropAspectRatio(ratioX: 3, ratioY: 2));

    printOut("Path to picked image $path");

    homeController.roomPickedImages.insert(
        homeController.roomPickedImages.indexWhere(
            (element) => element.isReal == false && element.isPath == false),
        RoomImagesModel(path, false, true));
    if (path == null) {
      throw LocalImagePickingUnknownReasonFailureException();
    }
  }
}

// Future<dynamic> createUpcomingEvent(BuildContext context) {
//
//   return showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     backgroundColor: Colors.grey[200],
//     shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//       topLeft: Radius.circular(15),
//       topRight: Radius.circular(15),
//     )),
//     builder: (context) {
//       return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//         return DraggableScrollableSheet(
//             expand: false,
//             initialChildSize: 0.6,
//             builder: (BuildContext context, ScrollController scrollController) {
//               return Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: homeController.eventTitleController,
//                       keyboardType: TextInputType.name,
//                       decoration: InputDecoration(
//                         hintText: "e.g 50% discount",
//                         labelText: "Event Title",
//                         floatingLabelBehavior: FloatingLabelBehavior.always,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 42, vertical: 13),
//                       ),
//                       validator: (_) {
//                         if (homeController.eventTitleController.text.isEmpty) {
//                           return FIELD_REQUIRED_MSG;
//                         }
//                         return null;
//                       },
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         showAddCoHostBottomSheet(context);
//                         homeController.fetchAllUsers();
//                       },
//                       child: Container(
//                         padding:
//                             EdgeInsets.symmetric(vertical: 13, horizontal: 10),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(8)),
//                             border: Border.all(color: Colors.grey, width: 1)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Add Co-Hosts",
//                               style: TextStyle(fontSize: 16.sm),
//                             ),
//                             Icon(Icons.arrow_forward_ios_rounded)
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     InkWell(
//                       onTap: () async {
//                         showProductBottomSheet(context);
//                         await homeController.fetchUserProducts();
//                       },
//                       child: Container(
//                         padding:
//                             EdgeInsets.symmetric(vertical: 13, horizontal: 10),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(8)),
//                             border: Border.all(color: Colors.grey, width: 1)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Select Product",
//                               style: TextStyle(fontSize: 16.sm),
//                             ),
//                             Icon(Icons.arrow_forward_ios_rounded)
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         DatePicker.showDateTimePicker(context,
//                             showTitleActions: true,
//                             minTime: DateTime(2020, 5, 5, 20, 50),
//                             maxTime: DateTime(2030, 6, 7, 05, 09),
//                             onChanged: (date) {
//                           print('change $date in time zone ' +
//                               date.timeZoneOffset.inHours.toString());
//                         }, onConfirm: (date) {
//                           print('confirm $date');
//                           homeController.eventDate.value = date;
//                         }, locale: LocaleType.en);
//                       },
//                       child: Container(
//                         padding:
//                             EdgeInsets.symmetric(vertical: 13, horizontal: 10),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(8)),
//                             border: Border.all(color: Colors.grey, width: 1)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "When",
//                               style: TextStyle(fontSize: 16.sm),
//                             ),
//                             Icon(Icons.arrow_forward_ios_rounded)
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Private",
//                           ),
//                           CupertinoSwitch(
//                             value: isSwitched,
//                             onChanged: (value) {},
//                           ),
//                           // Switch(
//                           //   onChanged: toggleSwitch,
//                           //   value: isSwitched,
//                           //   activeColor: Colors.blue,
//                           //   activeTrackColor: Colors.yellow,
//                           //   inactiveThumbColor: Colors.redAccent,
//                           //   inactiveTrackColor: Colors.orange,
//                           // ),
//                         ],
//                       ),
//                     ),
//                     TextFormField(
//                       controller: homeController.eventTitleController,
//                       keyboardType: TextInputType.name,
//                       decoration: InputDecoration(
//                         hintText: "description",
//                         floatingLabelBehavior: FloatingLabelBehavior.always,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 42, vertical: 13),
//                       ),
//                       validator: (_) {
//                         if (homeController.eventTitleController.text.isEmpty) {
//                           return FIELD_REQUIRED_MSG;
//                         }
//                         return null;
//                       },
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                     ),
//                   ],
//                 ),
//               );
//             });
//       });
//     },
//   );
// }
