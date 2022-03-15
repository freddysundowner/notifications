import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:get/get.dart';

class NewChatPage extends StatelessWidget {

  final RoomController _homeController = Get.find<RoomController>();

  NewChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose user to chat with", style: TextStyle(color: Colors.black),),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0, top: 10, right: 10, left: 10),
        child: Container(
            child: _homeController.allUsersLoading.isFalse
                ? SizedBox(
                height: 0.4.sh,
                child: GetBuilder<RoomController>(
                  init: _homeController,
                    builder: (_dx) {
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
        ),
      ),
    );
  }
}
