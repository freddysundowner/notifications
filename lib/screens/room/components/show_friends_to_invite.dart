import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

Future<dynamic> showInviteFriendsBottomSheet(BuildContext context) {
  final RoomController _homeController = Get.find<RoomController>();

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
            builder: (BuildContext context, ScrollController scrollController) {
              return Obx(() {
                _homeController.fetchAllUsers();
                return Padding(
                  padding: const EdgeInsets.all(10.0),
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
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14.sp),
                              ),
                            ],
                          ),
                          IconButton(onPressed: () {

                          }, icon: const Icon(Icons.done))

                        ],
                      ),
                      SizedBox(
                        height: 0.03.sh,
                      ),
                      _homeController.allUsersLoading.isFalse
                          ? SizedBox(
                              height: 0.4.sh,
                              child: GetBuilder<RoomController>(builder: (_dx) {
                                return GridView.builder(
                                    shrinkWrap: true,
                                    // physics: ScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 0.7,
                                    ),
                                    itemCount: _dx.allUsers.length,
                                    itemBuilder: (context, index) {
                                      UserModel user = UserModel.fromJson(
                                          _dx.allUsers.elementAt(index));
                                      return InkWell(
                                        onTap: () {
                                          if (_homeController.toInviteUsers
                                              .contains(user)) {
                                            _homeController.toInviteUsers
                                                .remove(user);
                                          } else {
                                            _homeController.toInviteUsers
                                                .add(user);
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            Obx(() {
                                              return Center(
                                                child: user.profilePhoto == null
                                                    ? CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        foregroundImage: _homeController
                                                                .toInviteUsers
                                                                .contains(user)
                                                            ? const AssetImage(
                                                                "assets/icons/picked.png")
                                                            : null,
                                                        backgroundImage:
                                                            const AssetImage(
                                                                "assets/icons/profile_placeholder.png"))
                                                    : CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        foregroundImage: _homeController
                                                                .toInviteUsers
                                                                .contains(user)
                                                            ? const AssetImage(
                                                                "assets/icons/picked.png")
                                                            : null,
                                                        backgroundImage:
                                                            NetworkImage(imageUrl +
                                                                user.profilePhoto!),
                                                      ),
                                              );
                                            }),
                                            SizedBox(
                                              height: 0.01.sh,
                                            ),
                                            Text(
                                              user.userName!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.sp),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              }))
                          : const CircularProgressIndicator(color: Colors.black)
                    ],
                  ),
                );
              });
            });
      });
    },
  );
}
