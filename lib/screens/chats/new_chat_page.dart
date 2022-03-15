import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class NewChatPage extends StatelessWidget {

  final RoomController _homeController = Get.find<RoomController>();

  NewChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _homeController.fetchAllUsers();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a friend to chat with", style: TextStyle(color: Colors.black),),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5.0, top: 5, right: 10, left: 10),
          child: Obx(() {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                      height: 0.07.sh,
                      decoration: BoxDecoration(
                        color: Colors.black12, borderRadius: BorderRadius.circular(30)
                      ),
                      child: Row(
                        children: [
                          const Icon(Ionicons.search, color: Colors.grey,),
                          SizedBox(width: 0.03.sw,),
                          Expanded(
                            child: Center(
                              child: TextField(
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                                  border: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 0.01.sh,),
                  SizedBox(
                    height: 0.78.sh,
                      child: _homeController.allUsersLoading.isFalse
                          ? GetBuilder<RoomController>(
                          builder: (_dx) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: _dx.allUsers.length,
                            itemBuilder: (context, index) {
                              OwnerId user = OwnerId.fromJson(
                                  _dx.allUsers.elementAt(index));
                              return Container(
                                padding: const EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: () {

                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Obx(() {
                                            return Center(
                                              child: user.profilePhoto == null
                                                  ? CircleAvatar(
                                                  radius: 25,
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
                                                radius: 25,
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
                                            width: 0.04.sw,
                                          ),
                                          Text(
                                            "${user.firstName} ${user.lastName}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp),
                                          ),
                                        ],
                                      ),
                                      const Icon(Ionicons.add_circle_outline)
                                    ],
                                  ),
                                ),
                              );
                            });
                      }) : const Center(child: CircularProgressIndicator(color: Colors.black))

                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
