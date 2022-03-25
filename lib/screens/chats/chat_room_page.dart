import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/chat_controller.dart';
import 'package:fluttergistshop/models/chat_room_model.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class ChatRoomPage extends StatelessWidget {
  UserModel user;
  final ChatController _chatController = Get.find<ChatController>();
  TextEditingController messageController = TextEditingController();

  ChatRoomPage(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _chatController.readChats();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${user.firstName} ${user.lastName}",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Obx(() {
              return _chatController.currentChatLoading.isFalse
                  ? RefreshIndicator(
                    onRefresh: () => _chatController.getChatById(_chatController.currentChatId.value),
                    child: _chatController.currentChat.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: _chatController.currentChat.length,
                            itemBuilder: (context, index) {
                              printOut(_chatController.currentChat.length);
                              ChatRoomModel chat =
                                  _chatController.currentChat.elementAt(index);
                              return Align(
                                alignment: chat.sender !=
                                        _chatController.userId
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 0.5.sw,
                                        decoration: BoxDecoration(
                                            color: chat.sender ==
                                                _chatController.userId ? Theme.of(context).primaryColor : Colors.black26,
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            chat.message,
                                            style: TextStyle(
                                                color: chat.sender ==
                                                    _chatController.userId ? Colors.white : Colors.black, fontSize: 16.sp),
                                          ),
                                        ),
                                      ),
                                      Text(convertTime(chat.date))
                                    ],
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child: Text(
                              "Nothing here",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.sp),
                            ),
                          ),
                  )
                  : const Center(
                      child: CircularProgressIndicator(
                      color: Colors.black,
                    ));
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10, bottom: 10, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 0.07.sh,
                  width: 0.8.sw,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Center(
                        child: TextField(
                          controller: messageController,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: "Enter message here",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 16.sp),
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (messageController.text.trim().isNotEmpty) {
                      _chatController.sendMessage(messageController.text.trim(), user);
                      messageController.text = "";
                    }
                  },
                  child: Obx(() {
                      return Container(
                        height: 0.07.sh,
                        width: 0.12.sw,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: _chatController.sendingMessage.isFalse ? const Center(
                            child: Icon(
                          Ionicons.send,
                          color: Colors.white,
                        )) : Transform.scale(
                            scale: 0.3,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            )),
                      );
                    }
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
