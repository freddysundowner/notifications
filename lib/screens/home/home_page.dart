import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/screens/profile/profile.dart';
import 'package:fluttergistshop/screens/shops/shop_search_results.dart';
import 'package:fluttergistshop/screens/activities/activities_page.dart';
import 'package:fluttergistshop/screens/room/components/show_friends_to_invite.dart';
import 'package:fluttergistshop/screens/room/components/show_room_raised_hands.dart';
import 'package:fluttergistshop/screens/room/room_page.dart';
import 'package:fluttergistshop/screens/shops/shop_search_results.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/utils/Functions.dart';
import 'package:fluttergistshop/utils/button.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class HomePage extends StatelessWidget {
  TextEditingController titleFieldController = TextEditingController();

  final RoomController _homeController = Get.put(RoomController());
  OwnerId currentUser = OwnerId(
      id: Get.find<AuthController>().usermodel.value!.id,
      bio: Get.find<AuthController>().usermodel.value!.bio,
      email: Get.find<AuthController>().usermodel.value!.email,
      firstName: Get.find<AuthController>().usermodel.value!.firstName,
      lastName: Get.find<AuthController>().usermodel.value!.lastName,
      userName: Get.find<AuthController>().usermodel.value!.userName,
      profilePhoto: Get.find<AuthController>().usermodel.value!.profilePhoto);

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Get.to(() => ShopSearchResults());
            },
            child: const Icon(
              Ionicons.search,
              color: Colors.grey,
            ),
          ),
          actions: [
            Image.asset(
              "assets/icons/wallet_icon.png",
              color: Colors.grey,
              width: 0.06.sw,
              height: 0.005.sh,
            ),
            SizedBox(
              width: 0.05.sw,
            ),
            InkWell(
              onTap: () {
                Get.to(const ActivitiesPage());
              },
              child: const Icon(
                Ionicons.notifications,
                color: Colors.grey,
                size: 30,
              ),
            ),
            SizedBox(
              width: 0.05.sw,
            ),
            InkWell(
              onTap: () {
                Get.to(() => Profile());
              },
              child: SizedBox(
                height: 0.005.sh,
                width: 0.07.sw,
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "http://52.43.151.113/public/img/61fb9094d59efb5046a99946.png"),
                ),
              ),
            ),
            SizedBox(
              width: 0.02.sw,
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
          ),
          child: Obx(() {
            return SizedBox(
              height: _homeController.currentRoom.value.id != null
                  ? 0.18.sh
                  : 0.1.sh,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          showRoomTypeBottomSheet(context);
                        },
                        child: Container(
                          width: 0.6.sw,
                          height: 0.07.sh,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).primaryColor),
                          child: Center(
                            child: Text(
                              "Create a room",
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 0.1.sw,
                      ),
                      const Icon(
                        Ionicons.chatbox_outline,
                        color: Colors.grey,
                        size: 35,
                      ),
                      SizedBox(
                        width: 0.02.sw,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.008.sh,
                  ),
                  Obx(() {
                    if (_homeController.currentRoom.value.id != null) {
                      return buildCurrentRoom(context);
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            );
          }),
        ),
        body: Obx(() {
          if (_homeController.isLoading.isFalse) {
            return buildIndividualRoomCard();
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black87,
            ));
          }
        }));
  }

  buildIndividualRoomCard() {
    printOut("Home rooms ${_homeController.roomsList}");
    return Obx(() => ListView.builder(
        itemCount: _homeController.roomsList.length,
        itemBuilder: (context, index) {
          RoomModel roomModel =
              RoomModel.fromJson(_homeController.roomsList.elementAt(index));

          return InkWell(
            onTap: () async {
              Get.to(RoomPage(
                roomId: roomModel.id!,
              ));

              await _homeController.fetchRoom(roomModel.id!);

              OwnerId currentUser = OwnerId(
                  id: Get.find<AuthController>().usermodel.value!.id,
                  bio: Get.find<AuthController>().usermodel.value!.bio,
                  email: Get.find<AuthController>().usermodel.value!.email,
                  firstName:
                      Get.find<AuthController>().usermodel.value!.firstName,
                  lastName:
                      Get.find<AuthController>().usermodel.value!.lastName,
                  userName:
                      Get.find<AuthController>().usermodel.value!.userName,
                  profilePhoto:
                      Get.find<AuthController>().usermodel.value!.profilePhoto);

              await _homeController.addUserToRoom(currentUser);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 0.1,
                        blurRadius: 0.5,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ]),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          roomModel.hostIds!.length.toString(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 0.006.sw),
                        const Icon(
                          Ionicons.people,
                          color: Colors.grey,
                          size: 20,
                        ),
                        SizedBox(width: 0.03.sw),
                        Text(
                          roomModel.userIds!.length.toString(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 0.006.sw),
                        const Icon(
                          Ionicons.chatbubble_outline,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.1.sh,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: roomModel.hostIds?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: roomModel.hostIds?[index].profilePhoto ==
                                        null
                                    ? const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/icons/profile_placeholder.png"))
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(imageUrl +
                                            roomModel
                                                .hostIds![index].profilePhoto!),
                                      ));
                          }),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        roomModel.title!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      height: 0.01.sh,
                    ),
                    Divider(
                      color: Colors.grey[200],
                      height: 0.001.sh,
                    ),
                    SizedBox(
                      height: 0.01.sh,
                    ),
                    SizedBox(
                      height: 0.12.sh,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: roomModel.productIds![0].images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: Center(
                                  child: Image.network(
                                    imageUrl +
                                        roomModel.productIds![0].images[index],
                                    height: 0.08.sh,
                                    width: 0.12.sw,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  InkWell buildCurrentRoom(BuildContext context) {
    RoomModel room = _homeController.currentRoom.value;
    return InkWell(
      onTap: () {
        Get.to(RoomPage(
          roomId: room.id!,
        ));
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  room.hostIds!.elementAt(0).profilePhoto == null
                      ? const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                              "assets/icons/profile_placeholder.png"))
                      : CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(imageUrl +
                              room.hostIds!.elementAt(0).profilePhoto!),
                        ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await _homeController.leaveRoom(currentUser);
                    },
                    child: Image.asset(
                      "assets/icons/leave_room.png",
                      height: 0.1.sh,
                      width: 0.07.sw,
                    ),
                  ),
                  SizedBox(
                    width: 0.01.sw,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (_homeController.currentRoom.value.hostIds!
                          .contains(currentUser)) {
                        showRaisedHandsBottomSheet(context);
                      } else {
                        await _homeController.addUserToRaisedHands(currentUser);
                      }
                    },
                    icon: const Icon(
                      Ionicons.hand_right,
                      color: Colors.black54,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 0.01.sw,
                  ),
                  IconButton(
                    onPressed: () {
                      showInviteFriendsBottomSheet(context);
                    },
                    icon: const Icon(
                      Icons.add_box,
                      color: Colors.black54,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 0.009.sw,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Ionicons.mic,
                      color: Colors.black54,
                      size: 30,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showRoomTypeBottomSheet(BuildContext context) {
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.black38),
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
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.black38),
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
                          )
                        ],
                      ),
                      SizedBox(
                        height: 0.04.sh,
                      ),
                      InkWell(
                          onTap: () async {
                            showProductBottomSheet(context);
                            await _homeController.fetchUserProducts();
                          },
                          child: Button(
                            text: "Proceed",
                            width: 0.8.sw,
                          ))
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
                controller: titleFieldController,
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "How would you describe your room?",
                ),
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
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
                            fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(
                      width: 0.03.sw,
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "Okay".toUpperCase(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.sp),
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
                        style:
                            TextStyle(color: Colors.black87, fontSize: 16.sp),
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
                                          childAspectRatio: 0.99,
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
                                              _homeController
                                                  .roomPickedProductId
                                                  .value = product.id!;
                                              _homeController
                                                      .roomPickedProductPrice
                                                      .value =
                                                  product.price.toString();

                                              showChooseImagesBottomSheet(
                                                  context, product);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                      child: Image.network(
                                                        imageUrl +
                                                            product
                                                                .images.first,
                                                        height: 0.1.sh,
                                                        width: 0.2.sw,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                      child: Text(
                                                    product.name,
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
    _homeController.roomHosts.value = [];

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
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 16.sp),
                            ),
                          ],
                        ),
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
                        child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // physics: ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.99,
                            ),
                            itemCount: product.images.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {},
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
                                        child: Image.network(
                                          imageUrl +
                                              product.images.elementAt(index),
                                          height: 0.1.sh,
                                          width: 0.2.sw,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
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

  Future<dynamic> showAddCoHostBottomSheet(BuildContext context) {
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
                        "Add Co-hosts",
                        style:
                            TextStyle(color: Colors.black87, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      Obx(() {
                        return _homeController.allUsersLoading.isFalse
                            ? SizedBox(
                                height: 0.55.sh,
                                child: _homeController.allUsers.isNotEmpty
                                    ? GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        // physics: ScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 0.99,
                                        ),
                                        itemCount:
                                            _homeController.allUsers.length,
                                        itemBuilder: (context, index) {
                                          UserModel user = UserModel.fromJson(
                                              _homeController.allUsers
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
                                                              null
                                                          ? CircleAvatar(
                                                              radius: 35,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              foregroundImage: _homeController
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
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
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
                                                  user.userName!,
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
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Button(text: "Continue", width: 0.9.sw))
                    ],
                  ),
                );
              });
        });
      },
    );
  }
}
