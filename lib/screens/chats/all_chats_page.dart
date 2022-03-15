import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/screens/chats/new_chat_page.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class AllChatsPage extends StatelessWidget {
  const AllChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats", style: TextStyle(color: Colors.black),),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: ListView.builder(
          itemCount: 12,
            itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundImage: AssetImage(
                          "assets/icons/profile_placeholder.png")),
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
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(NewChatPage()),
        child: const Icon(Ionicons.add, color: Colors.white,),
      ),
    );
  }
}
