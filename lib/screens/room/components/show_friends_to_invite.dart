import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/services/notification_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

Future<dynamic> showInviteFriendsBottomSheet(BuildContext context) {
  final RoomController _homeController = Get.find<RoomController>();
  _homeController.searchUsersController.text = "";
  _homeController.toInviteUsers.value = [];

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
            initialChildSize: 0.81,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              _homeController.fetchAllUsers();
              return Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10, top: 10, bottom: 2),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Ionicons.people,
                              color: Colors.grey,
                            ),
                            Text(
                              "Invite friends",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 14.sp),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () async {
                              Get.back();
                              printOut("invited users ${_homeController.toInviteUsers.length}");
                              if (_homeController.toInviteUsers.isNotEmpty) {
                                await NotificationApi().sendNotification(
                                    _homeController.toInviteUsers,
                                    "Room invite",
                                    "You've been invited to join room ${_homeController.currentRoom.value.title} by "
                                        "${FirebaseAuth.instance.currentUser!.displayName}",
                                    "RoomScreen",
                                    _homeController.currentRoom.value.id!);
                              }
                            },
                            icon: const Icon(Icons.done))
                      ],
                    ),
                    SizedBox(
                      height: 0.007.sh,
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
                      height: 0.03.sh,
                    ),
                    Obx(() => Container(
                          child: _homeController.allUsersLoading.isFalse
                              ? SizedBox(
                                  height: 0.6.sh,
                                  child: GetBuilder<RoomController>(
                                      builder: (_dx) {
                                    return _dx.searchedUsers.isNotEmpty
                                        ? GridView.builder(
                                            shrinkWrap: true,
                                            // physics: ScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              childAspectRatio: 0.6,
                                            ),
                                            itemCount: _dx.searchedUsers.length,
                                            itemBuilder: (context, index) {
                                              UserModel user =
                                                  UserModel.fromJson(_dx
                                                      .searchedUsers
                                                      .elementAt(index));
                                              return InkWell(
                                                onTap: () {
                                                  if (_homeController
                                                      .toInviteUsers
                                                      .contains(user.id)) {
                                                    _homeController
                                                        .toInviteUsers
                                                        .remove(user.id);
                                                  } else {
                                                    _homeController
                                                        .toInviteUsers
                                                        .add(user.id);
                                                  }
                                                },
                                                child: Column(
                                                  children: [
                                                    Obx(() => Center(
                                                      child: user.profilePhoto ==
                                                              "" || user.profilePhoto!.length > 300
                                                          ? CircleAvatar(
                                                              radius: 35,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              foregroundImage: _homeController
                                                                      .toInviteUsers
                                                                      .contains(
                                                                          user.id)
                                                                  ? const AssetImage(
                                                                      "assets/icons/picked.png")
                                                                  : null,
                                                              backgroundImage:
                                                                  const AssetImage(
                                                                      "assets/icons/profile_placeholder.png"))
                                                          : CircleAvatar(
                                                              radius: 35,
                                                              onBackgroundImageError: (object, stackTrace) => const AssetImage(
                                                                  "assets/icons/profile_placeholder.png"),
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              foregroundImage: _homeController
                                                                      .toInviteUsers
                                                                      .contains(
                                                                          user.id)
                                                                  ? const AssetImage(
                                                                      "assets/icons/picked.png")
                                                                  : null,
                                                              backgroundImage:
                                                                  NetworkImage(user
                                                                      .profilePhoto!),
                                                            ),
                                                    )),
                                                    SizedBox(
                                                      height: 0.01.sh,
                                                    ),
                                                    Text(
                                                      "${user.firstName} ${user.lastName}"
                                                                  .length >
                                                              10
                                                          ? "${user.firstName} ${user.lastName}"
                                                                  .substring(
                                                                      0, 10) +
                                                              "..."
                                                          : "${user.firstName} ${user.lastName}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.sp),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            })
                                        : Center(
                                            child: Text(
                                              "No users yet",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16.sp),
                                            ),
                                          );
                                  }))
                              : const CircularProgressIndicator(
                                  color: Colors.black),
                        ))
                  ],
                ),
              );
            });
      });
    },
  );
}
