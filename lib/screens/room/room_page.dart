import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/screens/home/main_page.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/screens/profile/followers_following_page.dart';
import 'package:fluttergistshop/screens/profile/profile.dart';
import 'package:fluttergistshop/services/dynamic_link_services.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/services/room_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share/share.dart';

import 'components/show_friends_to_invite.dart';
import 'components/show_room_raised_hands.dart';

class RoomPage extends StatelessWidget {
  final RoomController _homeController = Get.find<RoomController>();

  OwnerId currentUser = OwnerId(
      id: Get.find<AuthController>().usermodel.value!.id,
      bio: Get.find<AuthController>().usermodel.value!.bio,
      email: Get.find<AuthController>().usermodel.value!.email,
      firstName: Get.find<AuthController>().usermodel.value!.firstName,
      lastName: Get.find<AuthController>().usermodel.value!.lastName,
      userName: Get.find<AuthController>().usermodel.value!.userName,
      profilePhoto: Get.find<AuthController>().usermodel.value!.profilePhoto);

  String roomId;

  RoomPage({Key? key, required this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Listener for room activities
    roomListener();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Obx(() {
          return Text(
            _homeController.currentRoom.value.title ?? " ",
            style: const TextStyle(color: Colors.white),
          );
        }),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                RoomModel roo = RoomModel.fromJson(await RoomAPI()
                    .getRoomById(_homeController.currentRoom.value.id!));
                print(Get.find<AuthController>().usermodel.value!.roomuid);
                if (roo.recordingIds!.indexWhere((element) =>
                        element ==
                        Get.find<AuthController>().usermodel.value!.roomuid) !=
                    -1) {
                  return await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            "Are you sure you want to stop the recording?"),
                        content: Text(
                            "once you stop the recording you cannot record again for this room"),
                        actions: [
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              Navigator.pop(context, true);
                              _stopRecording();
                              Get.snackbar('', 'Recoding stopped...',
                                  backgroundColor: sc_snackBar,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2));
                            },
                          ),
                          FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            "Are you sure you want to start recording this room?"),
                        content: Text(
                            "The recorded audio wil be saved for 30 days only, for you to extend the time to have the audio, you have to upgrade your account to premium membership by going to your profile page and click upgrade account."),
                        actions: [
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              Navigator.pop(context, true);
                              _homeController.startrecordingAudio(
                                  token:
                                      _homeController.currentRoom.value.token,
                                  channelname: roomId);
                            },
                          ),
                          FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              icon: const Icon(Icons.fiber_smart_record)),
          IconButton(
              onPressed: () async {
                DynamicLinkService()
                    .createGroupJoinLink(
                        _homeController.currentRoom.value.id!, "room")
                    .then((value) async => await Share.share(value));
              },
              icon: const Icon(Icons.share))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  Get.offAll(MainPage());
                  await _homeController.leaveRoom(currentUser,
                      idRoom: _homeController.currentRoom.value.id);

                  _stopRecording();
                },
                child: Container(
                  height: 0.06.sh,
                  width: 0.4.sw,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red),
                  child: Center(
                      child: Text(
                    "Leave Room",
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  )),
                ),
              ),
              Row(
                children: [
                  Obx(() {
                    return _homeController.currentRoom.value.speakerIds !=
                                null &&
                            (_homeController.currentRoom.value.speakerIds!
                                    .indexWhere(
                                        (e) => e.id == currentUser.id) ==
                                -1)
                        ? IconButton(
                            onPressed: () async {
                              if ((_homeController.currentRoom.value.hostIds!
                                      .indexWhere(
                                          (e) => e.id == currentUser.id) !=
                                  -1)) {
                                showRaisedHandsBottomSheet(context);
                              } else {
                                await _homeController.raiseHand(
                                    context, currentUser);
                              }
                            },
                            icon: Stack(
                              children: [
                                const Icon(
                                  Ionicons.hand_right,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                                if (_homeController.currentRoom.value
                                        .raisedHands!.isNotEmpty &&
                                    (_homeController.currentRoom.value.hostIds!
                                            .indexWhere((e) =>
                                                e.id == currentUser.id) !=
                                        -1))
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Container(
                                      height: 0.03.sh,
                                      width: 0.04.sw,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                          child: Text(
                                        _homeController.currentRoom.value
                                            .raisedHands!.length
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp),
                                      )),
                                    ),
                                  )
                              ],
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
                    onPressed: () async {
                      printOut("showInviteFriendsBottomSheet");
                      showInviteFriendsBottomSheet(context);
                    },
                    icon: const Icon(
                      Icons.add_box,
                      color: Colors.black54,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 0.01.sw,
                  ),
                  Obx(() {
                    return _homeController.currentRoom.value.id != null
                        ? SizedBox(
                            height: 0.1.sh,
                            child: Obx(() {
                              //If user is not a speaker or a host, disable their audio

                              if (_homeController.currentRoom.value.userIds!
                                      .indexWhere(
                                          (e) => e.id == currentUser.id) ==
                                  -1) {
                                try {
                                  _homeController.engine.enableAudio();
                                  _homeController.engine.enableLocalAudio(true);

                                  _homeController.engine.muteLocalAudioStream(
                                      _homeController.audioMuted.value);
                                } catch (e) {
                                  printOut("Error disabling audio $e");
                                }
                              } else {
                                _homeController.engine
                                    .muteLocalAudioStream(true);
                                _homeController.engine.enableLocalAudio(false);
                              }

                              //If current room is loading, show a spinner
                              if (_homeController
                                  .isCurrentRoomLoading.isFalse) {
                                return Container(

                                    //If user is a speaker or host, show the mic icon, else don't show it
                                    child: (_homeController
                                                .currentRoom.value.userIds!
                                                .indexWhere((e) =>
                                                    e.id == currentUser.id) ==
                                            -1)
                                        ? IconButton(
                                            onPressed: () {
                                              //If user is muted, unmute and enbale their audio vice versa
                                              if (_homeController
                                                  .audioMuted.isFalse) {
                                                _homeController
                                                    .audioMuted.value = true;
                                                _homeController.engine
                                                    .muteLocalAudioStream(true);
                                              } else {
                                                _homeController
                                                    .audioMuted.value = false;
                                                _homeController.engine
                                                    .muteLocalAudioStream(
                                                        false);

                                                _homeController
                                                    .sendRoomNotification(
                                                        _homeController
                                                            .currentRoom.value);
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
                          )
                        : Transform.scale(
                            scale: 0.1,
                            child: const CircularProgressIndicator(
                              color: Colors.black,
                            ));
                  }),
                ],
              )
            ],
          ),
        ),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () {
            return _homeController
                .fetchRoom(_homeController.currentRoom.value.id!);
          },
          child: _homeController.isCurrentRoomLoading.isFalse
              ? _homeController.currentRoom.value.id != null
                  ? ListView(children: [
                      _homeController.userJoinedRoom.isFalse
                          ? Transform.scale(
                              scale: 0.2,
                              child: const CircularProgressIndicator(
                                color: Colors.black,
                              ))
                          : Container(),
                      RoomUser("Hosts"),
                      SizedBox(
                        width: 0.9.sw,
                        child: const Divider(
                          color: Colors.black12,
                        ),
                      ),
                      buildProducts(),
                      SizedBox(
                        width: 0.9.sw,
                        child: const Divider(
                          color: Colors.black12,
                        ),
                      ),
                      _homeController.currentRoom.value.speakerIds!.isNotEmpty
                          ? Column(
                              children: [
                                RoomUser("Speakers"),
                                SizedBox(
                                  width: 0.9.sw,
                                  child: const Divider(
                                    color: Colors.black12,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      RoomUser("Audience"),
                    ])
                  : const Center(child: CircularProgressIndicator())
              : const Center(
                  child: CircularProgressIndicator(
                  color: Colors.black87,
                )),
        );
      }),
    );
  }

  void _stopRecording() {
    if (_homeController.currentRoom.value.recordingsid != null) {
      _homeController.stopRecording(
          channelname: _homeController.currentRoom.value.id,
          uid: _homeController.currentRoom.value.recordingUid,
          resourceid: _homeController.currentRoom.value.resourceId,
          sid: _homeController.currentRoom.value.recordingsid);
    }
  }

  void roomListener() {
    customSocketIO.socketIO.on(roomId, (data) {
      var decodedData = jsonDecode(data);
      if (decodedData["roomId"] == roomId) {
        var user = OwnerId.fromJson(decodedData["userData"]);

        printOut("there is response, action  ${decodedData["action"]}");

        if (decodedData["action"] == "join") {
          //if user is not already in room, add them
          if (_homeController.currentRoom.value.invitedhostIds!
                  .indexWhere((element) => element == user.id) !=
              -1) {
            if (_homeController.currentRoom.value.hostIds!
                    .indexWhere((element) => element.id == user.id) ==
                -1) {
              _homeController.currentRoom.value.hostIds!.add(user);
              _homeController.currentRoom.refresh();
            }
          } else if (_homeController.currentRoom.value.userIds!
                  .indexWhere((element) => element.id == user.id) ==
              -1) {
            _homeController.currentRoom.value.userIds!.add(user);
            _homeController.currentRoom.refresh();
          }
        } else if (decodedData["action"] == "leave") {
          printOut("leaving");
          //Remove user who has left room
          try {
            _homeController.currentRoom.value.userIds!
                .removeWhere((element) => element.id == user.id);
            _homeController.currentRoom.value.speakerIds!
                .removeWhere((element) => element.id == user.id);
            _homeController.currentRoom.value.hostIds!
                .removeWhere((element) => element.id == user.id);
            _homeController.currentRoom.value.raisedHands!
                .removeWhere((element) => element.id == user.id);
          } catch (e, s) {
            printOut("Error removing user who has left from controller $e $s");
          }
          _homeController.currentRoom.refresh();
        } else if (decodedData["action"] == "room_ended") {
          if (_homeController.currentRoom.value.hostIds!.length != 1 ||
              _homeController.currentRoom.value.hostIds!
                      .indexWhere((element) => element.id == user.id) ==
                  -1) {
            printOut("room_ended");

            //Remove user from room that has ended, and show them a message.
            Get.snackbar('', 'Room ended',
                backgroundColor: sc_snackBar,
                colorText: Colors.white,
                duration: const Duration(seconds: 2));

            Future.delayed(const Duration(seconds: 3), () {
              _homeController.currentRoom.value = RoomModel();
              _homeController.leaveAgora();
              Get.offAll(MainPage());
            });
          }
        } else if (decodedData["action"] == "add_speaker") {
          printOut("add_speaker");

          if (_homeController.currentRoom.value.speakerIds!
                  .indexWhere((element) => element.id == user.id) ==
              -1) {
            _homeController.currentRoom.value.speakerIds!.add(user);

            //Tell user that they have been added to speaker and update room by adding user to speaker, removing them from raised hands, and from audience
            if (user.id == currentUser.id) {
              Get.snackbar('', 'You have been added to speaker',
                  backgroundColor: sc_snackBar,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2));
            }

            _homeController.currentRoom.value.userIds!
                .removeWhere((element) => element.id == user.id);
            _homeController.currentRoom.value.raisedHands!
                .removeWhere((element) => element.id == user.id);

            _homeController.currentRoom.refresh();
          }
        } else if (decodedData["action"] == "remove_speaker") {
          if (_homeController.currentRoom.value.userIds!
                  .indexWhere((element) => element.id == user.id) ==
              -1) {
            _homeController.currentRoom.value.userIds!.add(user);

            //Remove user from speaker and tell them and add them to audience
            printOut("remove_speaker");

            if (user.id == currentUser.id) {
              Get.snackbar('', 'You have been removed from being a speaker',
                  backgroundColor: sc_snackBar,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2));
            }

            _homeController.currentRoom.value.speakerIds!
                .removeWhere((element) => element.id == user.id);

            _homeController.currentRoom.refresh();
          }
        } else if (decodedData["action"] == "added_raised_hands") {
          printOut("added_raised_hands");

          if ((_homeController.currentRoom.value.raisedHands!
                  .indexWhere((element) => element.id == user.id) ==
              -1)) {
            //Show snackBar to the hosts of the room
            if (_homeController.currentRoom.value.hostIds!
                    .indexWhere((element) => element.id == currentUser.id) !=
                -1) {
              Get.snackbar('',
                  '${user.firstName} has raised their hand. Let them speak?',
                  backgroundColor: sc_snackBar,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2));
            }
            //Add user to raised hands
            _homeController.currentRoom.value.raisedHands!.add(user);
            _homeController.currentRoom.refresh();
          }
        }
      }
    });
  }

  Column buildProducts() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Products",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(
          height: 0.12.sh,
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 8.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _homeController
                          .currentRoom.value.productImages!.isNotEmpty
                      ? _homeController.currentRoom.value.productImages!.length
                      : 1,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Get.to(FullProduct(
                          product: _homeController.currentRoom.value.productIds!
                              .elementAt(0))),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Center(
                            child: _homeController
                                    .currentRoom.value.productImages!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: _homeController
                                        .currentRoom.value.productImages!
                                        .elementAt(index),
                                    height: 0.08.sh,
                                    width: 0.12.sw,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : Image.asset(
                                    "assets/icons/no_image.png",
                                    height: 0.08.sh,
                                    width: 0.12.sw,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }),
        ),
      ],
    );
  }
}

class RoomUser extends StatelessWidget {
  String title;
  final RoomController _homeController = Get.find<RoomController>();
  final UserController _userController = Get.find<UserController>();

  RoomUser(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    printOut(
        "hosts Length ${_homeController.currentRoom.value.hostIds!.length}");
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(
          height: 0.02.sh,
        ),
        GetBuilder<RoomController>(builder: (_dx) {
          List<OwnerId> user = title == "Hosts"
              ? _dx.currentRoom.value.hostIds!
              : title == "Speakers"
                  ? _dx.currentRoom.value.speakerIds!
                  : _dx.currentRoom.value.userIds!;
          return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // physics: ScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.8,
              ),
              itemCount: user.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    showUserBottomSheet(context, user.elementAt(index));
                  },
                  child: Column(
                    children: [
                      title == "Hosts"
                          ? Stack(children: [
                              Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: user.elementAt(index).profilePhoto ==
                                              "" ||
                                          user.elementAt(index).profilePhoto ==
                                              null
                                      ? const CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage(
                                              "assets/icons/profile_placeholder.png"))
                                      : CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              imageUrl +
                                                  user
                                                      .elementAt(index)
                                                      .profilePhoto!),
                                        )),
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Ionicons.star,
                                  color: Colors.redAccent,
                                  size: 12,
                                ),
                                padding: const EdgeInsets.all(1),
                              )
                            ])
                          : Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: user.elementAt(index).profilePhoto == "" ||
                                      user.elementAt(index).profilePhoto == null
                                  ? const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          "assets/icons/profile_placeholder.png"))
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(imageUrl +
                                          user.elementAt(index).profilePhoto!),
                                    )),
                      SizedBox(
                        height: 0.002.sh,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Center(
                            child: Text(
                          user.elementAt(index).userName == null
                              ? " "
                              : user.elementAt(index).userName!.length > 10
                                  ? user
                                          .elementAt(index)
                                          .userName!
                                          .substring(0, 9) +
                                      "..."
                                  : user.elementAt(index).userName!,
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                        )),
                      )
                    ],
                  ),
                );
              });
        }),
      ],
    );
  }

  Future<dynamic> showUserBottomSheet(BuildContext context, OwnerId user) {
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
              initialChildSize: 0.55,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          user.profilePhoto == "" || user.profilePhoto == null
                              ? const CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage(
                                      "assets/icons/profile_placeholder.png"))
                              : CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                      imageUrl + user.profilePhoto!),
                                ),
                          SizedBox(
                            width: 0.1.sw,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user.firstName} ${user.lastName}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.sp),
                              ),
                              SizedBox(
                                height: 0.01.sh,
                              ),
                              Text(
                                "${user.userName}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.sp),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.01.sh,
                    ),
                    // if (user.id !=
                    //     Get.find<AuthController>().usermodel.value!.id)
                    //   Padding(
                    //     padding: const EdgeInsets.only(left: 20.0),
                    //     child: Column(
                    //       children: [
                    //         Obx(() {
                    //           return InkWell(
                    //             onTap: () async {
                    //               if (user.followers!.contains(
                    //                   Get.find<AuthController>()
                    //                       .usermodel
                    //                       .value!
                    //                       .id)) {
                    //                 await Profile()
                    //                     .unFollowUser(UserModel(id: user.id));
                    //                 if (_homeController
                    //                         .currentRoom.value.hostIds!
                    //                         .indexWhere((element) =>
                    //                             element.id ==
                    //                             Get.find<AuthController>()
                    //                                 .usermodel
                    //                                 .value!
                    //                                 .id) !=
                    //                     -1) {
                    //                   _homeController
                    //                       .currentRoom
                    //                       .value
                    //                       .hostIds![_homeController
                    //                           .currentRoom.value.hostIds!
                    //                           .indexWhere((element) =>
                    //                               element.id ==
                    //                               Get.find<AuthController>()
                    //                                   .usermodel
                    //                                   .value!
                    //                                   .id)]
                    //                       .followersCount = _homeController
                    //                           .currentRoom
                    //                           .value
                    //                           .hostIds![_homeController
                    //                               .currentRoom.value.hostIds!
                    //                               .indexWhere((element) =>
                    //                                   element.id ==
                    //                                   Get.find<AuthController>()
                    //                                       .usermodel
                    //                                       .value!
                    //                                       .id)]
                    //                           .followersCount! -
                    //                       1;
                    //                 }
                    //                 if (_homeController
                    //                         .currentRoom.value.speakerIds!
                    //                         .indexWhere((element) =>
                    //                             element.id ==
                    //                             Get.find<AuthController>()
                    //                                 .usermodel
                    //                                 .value!
                    //                                 .id) !=
                    //                     -1) {
                    //                   _homeController
                    //                       .currentRoom
                    //                       .value
                    //                       .speakerIds![_homeController
                    //                           .currentRoom.value.speakerIds!
                    //                           .indexWhere((element) =>
                    //                               element.id ==
                    //                               Get.find<AuthController>()
                    //                                   .usermodel
                    //                                   .value!
                    //                                   .id)]
                    //                       .followersCount = _homeController
                    //                           .currentRoom
                    //                           .value
                    //                           .speakerIds![_homeController
                    //                               .currentRoom.value.speakerIds!
                    //                               .indexWhere((element) =>
                    //                                   element.id ==
                    //                                   Get.find<AuthController>()
                    //                                       .usermodel
                    //                                       .value!
                    //                                       .id)]
                    //                           .followersCount! -
                    //                       1;
                    //                 }
                    //
                    //                 if (_homeController
                    //                         .currentRoom.value.userIds!
                    //                         .indexWhere((element) =>
                    //                             element.id ==
                    //                             Get.find<AuthController>()
                    //                                 .usermodel
                    //                                 .value!
                    //                                 .id) !=
                    //                     -1) {
                    //                   _homeController
                    //                       .currentRoom
                    //                       .value
                    //                       .userIds![_homeController
                    //                           .currentRoom.value.userIds!
                    //                           .indexWhere((element) =>
                    //                               element.id ==
                    //                               Get.find<AuthController>()
                    //                                   .usermodel
                    //                                   .value!
                    //                                   .id)]
                    //                       .followersCount = _homeController
                    //                           .currentRoom
                    //                           .value
                    //                           .userIds![_homeController
                    //                               .currentRoom.value.userIds!
                    //                               .indexWhere((element) =>
                    //                                   element.id ==
                    //                                   Get.find<AuthController>()
                    //                                       .usermodel
                    //                                       .value!
                    //                                       .id)]
                    //                           .followersCount! -
                    //                       1;
                    //                 }
                    //               } else {
                    //                 await Profile()
                    //                     .followUser(UserModel(id: user.id));
                    //               }
                    //             },
                    //             child: Container(
                    //               width: 0.2.sw,
                    //               height: 0.04.sh,
                    //               decoration: BoxDecoration(
                    //                 color: user.followers!.contains(
                    //                         Get.find<AuthController>()
                    //                             .usermodel
                    //                             .value!
                    //                             .id)
                    //                     ? Colors.grey
                    //                     : Colors.green,
                    //                 borderRadius: BorderRadius.circular(5),
                    //               ),
                    //               child: Center(
                    //                 child: Text(
                    //                   user.followers!.contains(
                    //                           Get.find<AuthController>()
                    //                               .usermodel
                    //                               .value!
                    //                               .id)
                    //                       ? "UnFollow"
                    //                       : "Follow",
                    //                   style: TextStyle(
                    //                       color: Colors.white, fontSize: 12.sp),
                    //                 ),
                    //               ),
                    //             ),
                    //           );
                    //         }),
                    //       ],
                    //     ),
                    //   ),
                    // SizedBox(
                    //   height: 0.03.sh,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _userController.getUserFollowing(user.id!);
                              Get.to(FollowersFollowingPage("Following"));
                            },
                            child: Row(
                              children: [
                                Text(
                                  user.following != null
                                      ? user.following!.length.toString()
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
                              _userController.getUserFollowers(user.id!);
                              Get.to(FollowersFollowingPage("Followers"));
                            },
                            child: Row(
                              children: [
                                Text(
                                  user.followers != null
                                      ? user.followers!.length.toString()
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
                    ),
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          _userController.getUserProfile(user.id!);
                          Get.to(Profile());
                        },
                        child: Container(
                          height: 0.07.sh,
                          width: 0.9.sw,
                          decoration: BoxDecoration(
                              color: primarycolor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              "View profile".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.03.sh,
                    ),
                    Center(
                      child: Obx(() {
                        RoomModel room = _homeController.currentRoom.value;

                        return user.id !=
                                    Get.find<AuthController>()
                                        .usermodel
                                        .value!
                                        .id &&
                                room.hostIds!
                                        .indexWhere((e) => e.id == user.id) ==
                                    -1 &&
                                room.hostIds!.indexWhere((e) =>
                                        e.id ==
                                        Get.find<AuthController>()
                                            .usermodel
                                            .value!
                                            .id) !=
                                    -1
                            ? InkWell(
                                onTap: () async {
                                  Get.back();
                                  if (!room.speakerIds!.contains(user)) {
                                    _homeController.addUserToSpeaker(user);
                                  } else {
                                    _homeController.removeUserFromSpeaker(user);
                                  }
                                },
                                child: Container(
                                  height: 0.07.sh,
                                  width: 0.9.sw,
                                  decoration: BoxDecoration(
                                      color: primarycolor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Text(
                                      !(_homeController
                                                  .currentRoom.value.speakerIds!
                                                  .indexWhere(
                                                      (e) => e.id == user.id) !=
                                              -1)
                                          ? "Move to speakers".toUpperCase()
                                          : "Move to audience".toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.sp),
                                    ),
                                  ),
                                ),
                              )
                            : Container();
                      }),
                    ),
                  ],
                );
              });
        });
      },
    );
  }
}
