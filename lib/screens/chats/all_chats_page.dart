import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/chat_controller.dart';
import 'package:fluttergistshop/models/all_chats_model.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/screens/chats/chat_room_page.dart';
import 'package:fluttergistshop/screens/chats/new_chat_page.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class AllChatsPage extends StatelessWidget {
  final ChatController _chatController = Get.put(ChatController());

  AllChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _chatController.getUserChats();
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
              ? RefreshIndicator(
                  onRefresh: () => _chatController.getUserChats(),
                  child: _chatController.allUserChats.isNotEmpty
                      ? ListView.builder(
                          itemCount: _chatController.allUserChats.length,
                          itemBuilder: (context, index) {
                            AllChatsModel allChatsModel =
                                _chatController.allUserChats.elementAt(index);
                            return InkWell(
                              onTap: () {
                                _chatController.currentChatId.value =
                                    allChatsModel.id;
                                _chatController.currentChatUsers.value =
                                    allChatsModel.users;
                                _chatController.allUserChats.elementAt(index).unread = 0;
                                _chatController.allUserChats.refresh();

                                Get.to(
                                    ChatRoomPage(getOtherUser(allChatsModel)));
                                _chatController.getChatById(allChatsModel.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: getOtherUser(allChatsModel)
                                                  .profilePhoto ==
                                              ""
                                          ? const CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: AssetImage(
                                                  "assets/icons/profile_placeholder.png"))
                                          : CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: NetworkImage(
                                                  getOtherUser(allChatsModel)
                                                      .profilePhoto!),
                                            ),
                                    ),
                                    SizedBox(
                                      width: 0.03.sw,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                convertTime(allChatsModel
                                                    .lastMessageTime),
                                                style: TextStyle(
                                                    color:
                                                        allChatsModel.unread > 0
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : Colors.grey,
                                                    fontSize: 12.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 0.7.sw,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      allChatsModel
                                                                  .lastSender ==
                                                              _chatController
                                                                  .userId
                                                          ? "You: "
                                                          : getOtherUser(
                                                                      allChatsModel)
                                                                  .firstName! +
                                                              ": ",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14.sp)),
                                                  Text(
                                                    allChatsModel
                                                                .lastMessage.length >
                                                            40
                                                        ? allChatsModel
                                                                .lastMessage
                                                                .substring(
                                                                    0, 40) +
                                                            "..."
                                                        : allChatsModel
                                                            .lastMessage,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14.sp),
                                                  ),
                                                ],
                                              ),
                                              allChatsModel.unread > 0
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.only(left:
                                                              10, right: 10, bottom: 4, top: 4),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(100),
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      child: Center(
                                                          child: Text(
                                                            allChatsModel.unread
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10.sp),
                                                      )),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
                      : ListView(
                          children: [
                            SizedBox(
                              height: 0.6.sh,
                              child: Center(
                                child: Text(
                                  "No chats yet",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ],
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

  UserModel getOtherUser(AllChatsModel allChatsModel) {
    UserModel user = UserModel.fromJson({});

    for (var i = 0; i < allChatsModel.users.length; i++) {
      if (allChatsModel.userIds.elementAt(i) != _chatController.userId) {
        user = UserModel.fromJson(allChatsModel.users.elementAt(i));
        user.id = allChatsModel.users.elementAt(i)["id"];
        printOut("other user chat ${user.userName}");
      }
    }
    printOut("other user chat true ${user.id}");
    return user;
  }
}
