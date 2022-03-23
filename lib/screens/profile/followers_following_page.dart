import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class FollowersFollowingPage extends StatelessWidget {
  String type;
  final UserController _userController = Get.find<UserController>();

  FollowersFollowingPage(this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          type,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          return _userController.gettingFollowers.isFalse
              ? _userController.userFollowersFollowing.isNotEmpty
                  ? ListView.builder(
                      itemCount: _userController.userFollowersFollowing.length,
                      itemBuilder: (context, index) {
                        OwnerId user = OwnerId.fromJson(_userController
                            .userFollowersFollowing
                            .elementAt(index));

                        printOut(user.followers);
                        printOut("Do i follow this person? ${user.followers!.contains(FirebaseAuth
                            .instance.currentUser!.uid)}");

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  user.profilePhoto == null
                                      ? const CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage(
                                              "assets/icons/profile_placeholder.png"),
                                        )
                                      : CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              NetworkImage(user.profilePhoto!),
                                        ),
                                  SizedBox(
                                    width: 0.03.sw,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user.firstName} ${user.lastName}"
                                                    .length >
                                                30
                                            ? "${user.firstName} ${user.lastName}"
                                                    .substring(0, 30) +
                                                "..."
                                            : "${user.firstName} ${user.lastName}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp),
                                      ),
                                      Text(
                                        user.userName!,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () async {

                                  if (user.followers!.contains(FirebaseAuth
                                      .instance.currentUser!.uid)) {
                                    _userController
                                        .userFollowersFollowing
                                        .elementAt(index)["followers"].remove(FirebaseAuth
                                        .instance.currentUser!.uid);
                                    _userController.userFollowersFollowing.refresh();
                                    await UserAPI().unFollowAUser(FirebaseAuth
                                        .instance.currentUser!.uid, user.id!);

                                  }  else {
                                    _userController
                                        .userFollowersFollowing
                                        .elementAt(index)["followers"].add(FirebaseAuth
                                        .instance.currentUser!.uid);
                                    _userController.userFollowersFollowing.refresh();
                                    await UserAPI().followAUser(FirebaseAuth
                                        .instance.currentUser!.uid, user.id!);

                                  }

                                },
                                child: Container(
                                  width: 0.24.sw,
                                  height: 0.05.sh,
                                  decoration: BoxDecoration(
                                    color: user.followers!.contains(FirebaseAuth
                                        .instance.currentUser!.uid)
                                        ? Colors.grey
                                        : Colors.green,

                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      user.followers!.contains(FirebaseAuth
                                          .instance.currentUser!.uid)
                                          ? "UnFollow"
                                          : "Follow",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.sp),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })
                  : SizedBox(
                      height: 0.5.sh,
                      child: Text(
                        "You have now $type yet",
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                    )
              : SizedBox(
                  height: 0.5.sh,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ));
        }),
      ),
    );
  }
}
