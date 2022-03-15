import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/chat_controller.dart';
import 'package:fluttergistshop/models/all_chats_model.dart';
import 'package:fluttergistshop/screens/chats/new_chat_page.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class AllChatsPage extends StatelessWidget {
  final ChatController _chatController = Get.put(ChatController());

  AllChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats", style: TextStyle(color: Colors.black),),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Obx(() {
            return _chatController.gettingChats.isFalse ? ListView.builder(
              itemCount: _chatController.allUserChats.length,
                itemBuilder: (context, index) {
                AllChatsModel allChatsModel = _chatController.allUserChats.elementAt(index);
              return Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: allChatsModel.sender == null ? const CircleAvatar(
                          radius: 25,
                          backgroundColor:
                          Colors.transparent,
                          backgroundImage:
                          AssetImage(
                              "assets/icons/profile_placeholder.png"))
                    : CircleAvatar(
                radius: 25,
                backgroundColor:
                Colors.transparent,
                backgroundImage:
                NetworkImage(imageUrl +
                    allChatsModel.sender),
              ),
                    ),
                    SizedBox(width: 0.03.sw,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 0.7.sw,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Other user", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                              Text("now", style: TextStyle(color: Colors.grey, fontSize: 12.sp),)
                            ],
                          ),
                        ),
                        Text("A message I sent you last week. Heeellllloooooooooo......????".substring(0, 40) + "...", style: TextStyle(color: Colors.grey, fontSize: 14.sp),)
                      ],
                    )
                  ],
                ),
              );
            }) : const Center(child: CircularProgressIndicator(color: Colors.black,),);
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(NewChatPage()),
        child: const Icon(Ionicons.add, color: Colors.white,),
      ),
    );
  }
}
