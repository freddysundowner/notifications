import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ChatRoom",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  return Align(
                    alignment:
                        index.isEven ? Alignment.centerLeft : Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 0.5.sw,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Hey. wazzuuuppppp... jdijeiuedhne, judhneiuheiofh",
                            style: TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 5),
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
                          autofocus: true,
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
                Container(
                  height: 0.07.sh,
                  width: 0.12.sw,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(
                      child: Icon(
                        Ionicons.send,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
