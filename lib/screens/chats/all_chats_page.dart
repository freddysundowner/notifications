import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/chat_controller.dart';
import 'package:fluttergistshop/models/all_chats_model.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/screens/chats/chat_room_page.dart';
import 'package:fluttergistshop/screens/chats/new_chat_page.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class AllChatsPage extends StatelessWidget {
  final ChatController _chatController = Get.put(ChatController());

  AllChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Obx(() {
          return _chatController.gettingChats.isFalse
              ? _chatController.allUserChats.isNotEmpty
                  ? ListView.builder(
                      itemCount: _chatController.allUserChats.length,
                      itemBuilder: (context, index) {
                        AllChatsModel allChatsModel =
                            _chatController.allUserChats.elementAt(index);
                        return InkWell(
                          onTap: () {
                            _chatController.currentChatId.value = allChatsModel.id;
                            _chatController.currentChatUsers.value = allChatsModel.users;
                            Get.to(ChatRoomPage(getOtherUser(allChatsModel)));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: getOtherUser(allChatsModel)
                                              .profilePhoto ==
                                          null
                                      ? const CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: AssetImage(
                                              "assets/icons/profile_placeholder.png"))
                                      : CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(imageUrl +
                                              getOtherUser(allChatsModel)
                                                  .profilePhoto!),
                                        ),
                                ),
                                SizedBox(
                                  width: 0.03.sw,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 0.7.sw,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            getOtherUser(allChatsModel)
                                                    .firstName ??
                                                "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp),
                                          ),
                                          Text(
                                            convertTime(
                                                allChatsModel.lastMessageTime),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.sp),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      allChatsModel.lastMessage.length > 40
                                          ? allChatsModel.lastMessage
                                                  .substring(0, 40) +
                                              "..."
                                          : allChatsModel.lastMessage,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14.sp),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: Text(
                        "No chats yet",
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(NewChatPage()),
        child: const Icon(
          Ionicons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  OwnerId getOtherUser(AllChatsModel allChatsModel) {
    OwnerId user = OwnerId.fromJson({});

    for (var i = 0; i < allChatsModel.users.length; i++) {
      if (allChatsModel.users.elementAt(i) !=
          Get.find<AuthController>().usermodel.value!.id!) {
        user = OwnerId.fromJson(allChatsModel.users.elementAt(i));
        user.id = allChatsModel.users.elementAt(i)["id"];
        printOut("other user chat ${user.userName}");
      }
    }
    printOut("other user chat true ${user.id}");
    return user;
  }
}
