import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatRoom", style: const TextStyle(color: Colors.black),),
        centerTitle: false,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 0.07.sh,
              width: 0.8.sw,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Text(
                    "Enter message here", style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  ),
                ),
              ),
            ),

            Container(
              height: 0.07.sh,
              width: 0.12.sw,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: const Center(child: Icon(Ionicons.send, color: Colors.white,)),
            )
          ],
        ),
      ),
      body: Container(

      ),
    );
  }
}
