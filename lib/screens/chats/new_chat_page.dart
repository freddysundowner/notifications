import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/chat_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/screens/chats/chat_room_page.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class NewChatPage extends StatelessWidget {
  final RoomController _homeController = Get.find<RoomController>();
  final ChatController _chatController = Get.find<ChatController>();

  NewChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _homeController.fetchAllUsers();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select a friend to chat with",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 5.0, top: 5, right: 10, left: 10),
          child: Obx(() {
            return Column(
              children: [
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
                                  _homeController.searchChatUsersController,
                              autofocus: true,
                              onChanged: (text) =>
                                  _homeController.searchUsers(),
                              decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 16.sp),
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.sp),
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
                SizedBox(
                    height: 0.78.sh,
                    child: _homeController.allUsersLoading.isFalse
                        ? GetBuilder<RoomController>(builder: (_dx) {
                            return _dx.searchedUsers.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _dx.searchedUsers.length,
                                    itemBuilder: (context, index) {
                                      UserModel user = UserModel.fromJson(
                                          _dx.searchedUsers.elementAt(index));
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            _chatController.currentChat.value =
                                                [];
                                            _chatController
                                                .currentChatId.value = "";
                                            _chatController
                                                .getPreviousChat(user);

                                            Get.to(ChatRoomPage(user));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Center(
                                                    child: user.profilePhoto ==
                                                            null
                                                        ? const CircleAvatar(
                                                            radius: 25,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    "assets/icons/profile_placeholder.png"))
                                                        : CircleAvatar(
                                                            radius: 25,
                                                            onBackgroundImageError:
                                                                (Object,
                                                                        StackTrace) =>
                                                                    Image.asset(
                                                                        "assets/icons/profile_placeholder.png"),
                                                            backgroundColor:
                                                                Colors.black38,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    imageUrl +
                                                                        user.profilePhoto!),
                                                          ),
                                                  ),
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
                                              const Icon(
                                                  Ionicons.add_circle_outline)
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : Center(
                                    child: Text(
                                      "No users matching that name",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16.sp),
                                    ),
                                  );
                          })
                        : const Center(
                            child: CircularProgressIndicator(
                                color: Colors.black))),
              ],
            );
          }),
        ),
      ),
    );
  }
}
