import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/screens/activities/activities_page.dart';
import 'package:fluttergistshop/screens/chats/all_chats_page.dart';
import 'package:fluttergistshop/screens/favorites/favorites.dart';
import 'package:fluttergistshop/screens/profile/profile.dart';
import 'package:fluttergistshop/screens/room/components/show_friends_to_invite.dart';
import 'package:fluttergistshop/screens/room/components/show_room_raised_hands.dart';
import 'package:fluttergistshop/screens/shops/shop_search_results.dart';
import 'package:fluttergistshop/screens/wallet/wallet_page.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import 'create_room.dart';

class HomePage extends StatelessWidget {
  AuthController authController = Get.find<AuthController>();

  final RoomController _homeController = Get.put(RoomController());
  final UserController _userController = Get.put(UserController());

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
              // _shopController.getShops();
            },
            child: const Icon(
              Ionicons.search,
              color: Colors.grey,
            ),
          ),
          actions: [
            InkWell(
              onTap: () => Get.to(WalletPage()),
              child: Image.asset(
                "assets/icons/wallet_icon.png",
                color: Colors.grey,
                width: 0.06.sw,
                height: 0.005.sh,
              ),
            ),
            SizedBox(
              width: 0.05.sw,
            ),
            InkWell(
              onTap: () => Get.to(() => Favorites()),
              child: Image(
                image: AssetImage(
                  "assets/images/tab_saved.png",
                ),
                width: 15.w,
              ),
            ),
            SizedBox(
              width: 0.05.sw,
            ),
            InkWell(
              onTap: () {
                Get.to(ActivitiesPage());
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
                _userController.getUserProfile(authController.currentuser!.id!);
                Get.to(Profile());
              },
              child: CachedNetworkImage(
                imageUrl: authController.currentuser!.profilePhoto!,
                imageBuilder: (context, imageProvider) => Container(
                  width: 0.08.sw,
                  height: 0.05.sh,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Transform.scale(
                    scale: 0.3,
                    child: const CircularProgressIndicator(
                      color: Colors.black,
                    )),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/icons/profile_placeholder.png",
                  width: 0.08.sw,
                  height: 0.05.sh,
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
                  : 0.11.sh,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          _homeController.newRoomTitle.value = " ";
                          _homeController.newRoomType.value = " ";

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
                      InkWell(
                        onTap: () => Get.to(AllChatsPage()),
                        child: const Icon(
                          Ionicons.chatbox_outline,
                          color: Colors.grey,
                          size: 35,
                        ),
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
          if (_homeController.isLoading.isFalse ||
              _homeController.isCurrentRoomLoading.isFalse) {
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
    return Obx(() => RefreshIndicator(
        onRefresh: () {
          return _homeController.getRooms();
        },
        child: _homeController.roomsList.isNotEmpty
            ? ListView.builder(
                itemCount: _homeController.roomsList.length,
                itemBuilder: (context, index) {
                  RoomModel roomModel = RoomModel.fromJson(
                      _homeController.roomsList.elementAt(index));

                  return InkWell(
                    onTap: () async {
                      if (roomModel.id != null) {
                        await _homeController.joinRoom(roomModel.id!);
                      } else {
                        Get.snackbar('', "Room ended");
                      }
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
                                offset:
                                    Offset(0, 5), // changes position of shadow
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
                                        child: roomModel.hostIds?[index]
                                                    .profilePhoto ==
                                                ""
                                            ? const CircleAvatar(
                                                radius: 22,
                                                backgroundImage: AssetImage(
                                                    "assets/icons/profile_placeholder.png"))
                                            : CircleAvatar(
                                                radius: 22,
                                                onBackgroundImageError: (object,
                                                        stacktrace) =>
                                                    const AssetImage(
                                                        "assets/icons/profile_placeholder.png"),
                                                backgroundImage: NetworkImage(
                                                    roomModel.hostIds![index]
                                                        .profilePhoto!),
                                              ));
                                  }),
                            ),
                            roomModel.title != " "
                                ? Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          roomModel.title!,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 0.01.sh,
                                      ),
                                    ],
                                  )
                                : Container(),
                            Divider(
                              color: Colors.grey[200],
                              height: 0.001.sh,
                            ),
                            SizedBox(
                              height: 0.01.sh,
                            ),
                            SizedBox(
                              height: 0.06.sh,
                              child: roomModel.productIds!.isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          roomModel.productImages!.isNotEmpty
                                              ? roomModel.productImages!.length
                                              : 1,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.white),
                                          child: Center(
                                            child: roomModel
                                                    .productImages!.isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl: roomModel
                                                        .productImages![index],
                                                    height: 0.06.sh,
                                                    width: 0.12.sw,
                                                    fit: BoxFit.fill,
                                                    placeholder: (context,
                                                            url) =>
                                                        const CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      "assets/icons/no_image.png",
                                                      height: 0.06.sh,
                                                      width: 0.12.sw,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                                : Image.asset(
                                                    "assets/icons/no_image.png",
                                                    height: 0.06.sh,
                                                    width: 0.12.sw,
                                                    fit: BoxFit.fill,
                                                  ),
                                          ),
                                        );
                                      })
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : ListView(children: [
                SizedBox(
                  height: 0.8.sh,
                  child: Center(
                      child: Text(
                    "There are no rooms at the moment",
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  )),
                )
              ])));
  }

  InkWell buildCurrentRoom(BuildContext context) {
    var hosts = [];
    RoomModel room = _homeController.currentRoom.value;

    hosts =
        room.hostIds!.length > 5 ? room.hostIds!.sublist(0, 5) : room.hostIds!;

    return InkWell(
      onTap: () async {
        await _homeController.joinRoom(room.id!);
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
                  children: hosts.map((e) {
                var index = room.hostIds!.indexOf(e);
                return Padding(
                  padding: EdgeInsets.only(left: (30.0 * index)),
                  child: e.profilePhoto == ""
                      ? const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                              "assets/icons/profile_placeholder.png"))
                      : CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(imageUrl + e.profilePhoto!),
                        ),
                );
              }).toList()),
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
                  Obx(() {
                    return (_homeController.currentRoom.value.speakerIds!
                                .indexWhere((e) => e.id == currentUser.id) ==
                            -1)
                        ? IconButton(
                            onPressed: () async {
                              if ((_homeController.currentRoom.value.hostIds!
                                      .indexWhere(
                                          (e) => e.id == currentUser.id) ==
                                  0)) {
                                showRaisedHandsBottomSheet(context);
                              } else {
                                await _homeController
                                    .addUserToRaisedHands(currentUser);
                              }
                            },
                            icon: const Icon(
                              Ionicons.hand_right,
                              color: Colors.black54,
                              size: 30,
                            ),
                          )
                        : Container(
                            height: 0.06.sh,
                          );
                  }),
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
                  SizedBox(
                    height: _homeController.isCurrentRoomLoading.isFalse
                        ? 0.1.sh
                        : 0.001.sh,
                    child: Obx(() {
                      //If user is not a speaker or a host, disable their audio
                      if ((_homeController.currentRoom.value.hostIds!
                                  .indexWhere((e) => e.id == currentUser.id) ==
                              0) &&
                          (_homeController.currentRoom.value.speakerIds!
                                  .indexWhere((e) => e.id == currentUser.id) ==
                              0)) {
                        try {
                          _homeController.engine.enableLocalAudio(true);
                        } catch (e) {
                          printOut("Error disabling audio $e");
                        }
                      }

                      //If current room is loading, show a spinner
                      if (_homeController.isCurrentRoomLoading.isFalse) {
                        return Container(

                            //If user is a speaker or host, show the mic icon, else don't show it
                            child: (_homeController.currentRoom.value.hostIds!
                                            .indexWhere((e) =>
                                                e.id == currentUser.id) ==
                                        0) ||
                                    (_homeController
                                            .currentRoom.value.speakerIds!
                                            .indexWhere((e) =>
                                                e.id == currentUser.id) ==
                                        0)
                                ? IconButton(
                                    onPressed: () {
                                      //If user is muted, unmute and enbale their audio vice versa
                                      if (_homeController.audioMuted.isFalse) {
                                        _homeController.audioMuted.value = true;
                                        _homeController.engine
                                            .muteLocalAudioStream(true);
                                      } else {
                                        _homeController.audioMuted.value =
                                            false;
                                        _homeController.engine
                                            .muteLocalAudioStream(false);
                                      }
                                    },
                                    icon: Icon(
                                      //If audio is not muted, show mic icon, if not show mic off
                                      _homeController.audioMuted.isFalse
                                          ? Ionicons.mic
                                          : Ionicons.mic_off,
                                      color: Colors.black54,
                                      size: 30,
                                    ),
                                  )
                                : Container());
                      } else {
                        return Transform.scale(
                            scale: 0.3,
                            child: const CircularProgressIndicator(
                              color: Colors.black,
                            ));
                      }
                    }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
