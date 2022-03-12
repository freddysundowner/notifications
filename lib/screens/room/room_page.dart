import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/home_controller.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import 'components/show_friends_to_invite.dart';
import 'components/show_room_raised_hands.dart';

class RoomPage extends StatelessWidget {
  final HomeController _homeController = Get.find<HomeController>();

  String roomId;

  RoomPage({Key? key, required this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title:  Text(
          _homeController.currentRoom.value.title!,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 0.07.sh,
                  width: 0.4.sw,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red),
                  child: Center(
                      child: Text(
                    "Exit Room",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  )),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showRaisedHandsBottomSheet(context);
                    },
                    icon: const Icon(
                      Ionicons.hand_right,
                      color: Colors.black54,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 0.01.sw,
                  ),
                  IconButton(
                    onPressed: () {
                      showInviteFriendsBottomSheet(context);
                    },
                    icon: const Icon(
                      Icons.add_box,
                      color: Colors.black54,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 0.01.sw,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Ionicons.mic,
                      color: Colors.black54,
                      size: 30,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Obx(() {
        return _homeController.isCurrentRoomLoading.isFalse
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    RoomUser("Hosts"),
                    SizedBox(
                      width: 0.9.sw,
                      child: const Divider(
                        color: Colors.black12,
                      ),
                    ),
                    buildProducts(),
                    SizedBox(
                      width: 0.9.sw,
                      child: const Divider(
                        color: Colors.black12,
                      ),
                    ),
                    _homeController.currentRoom.value.speakerIds!.isNotEmpty
                        ? Column(
                       children: [
                         RoomUser("Speakers"),
                         SizedBox(
                           width: 0.9.sw,
                           child: const Divider(
                             color: Colors.black12,
                           ),
                         ),
                       ],
                     ): Container(),

                    RoomUser("Audience"),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                color: Colors.black87,
              ));
      }),
    );
  }

  Column buildProducts() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Products",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(
          height: 0.12.sh,
          child: GetBuilder<HomeController>(

            builder: (_hc) {
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _hc.currentRoom.value.productIds!.elementAt(0).images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Center(
                            child: Image.network(
                              imageUrl + _hc.currentRoom.value.productIds!.elementAt(0).images.elementAt(index),
                              height: 0.08.sh,
                              width: 0.12.sw,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
          ),
        ),
      ],
    );
  }
}

class RoomUser extends StatelessWidget {
  String title;
  final HomeController _homeController = Get.find<HomeController>();

  RoomUser(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomModel roomModel = _homeController.currentRoom.value;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(
          height: 0.02.sh,
        ),
        GetBuilder<HomeController>(
            builder: (_dx) => GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // physics: ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                ),
                itemCount: _dx.currentRoom.value.hostIds!.length,
                itemBuilder: (context, index) {
                  RoomModel room = _dx.currentRoom.value;

                  return InkWell(
                    onTap: () {
                      showUserBottomSheet(context);
                    },
                    child: Column(
                      children: [
                        title == "Hosts"
                            ? Stack(children: [
                                Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: room.hostIds![index].profilePhoto ==
                                            null
                                        ? const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/icons/profile_placeholder.png"))
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                imageUrl +
                                                    room.hostIds![index]
                                                        .profilePhoto!),
                                          )),
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(
                                    Ionicons.star,
                                    color: Colors.redAccent,
                                    size: 12,
                                  ),
                                  padding: const EdgeInsets.all(1),
                                )
                              ])
                            : Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: room.hostIds![index].profilePhoto == null
                                    ? const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/icons/profile_placeholder.png"))
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(imageUrl +
                                            room.hostIds![index].profilePhoto!),
                                      )),
                        SizedBox(
                          height: 0.01.sh,
                        ),
                        Center(
                            child: Text(
                          room.hostIds![index].userName!,
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        ))
                      ],
                    ),
                  );
                })),
      ],
    );
  }

  Future<dynamic> showUserBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      )),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return DraggableScrollableSheet(
              initialChildSize: 0.5,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "http://52.43.151.113/public/img/61fb9094d59efb5046a99946.png"),
                            radius: 35,
                          ),
                          SizedBox(
                            width: 0.1.sw,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Full name",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.sp),
                              ),
                              SizedBox(
                                height: 0.01.sh,
                              ),
                              Text(
                                "User name",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.sp),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    Container(
                      height: 0.07.sh,
                      width: 0.9.sw,
                      decoration: BoxDecoration(
                          color: primarycolor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          "View profile".toUpperCase(),
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.03.sh,
                    ),
                    Container(
                      height: 0.07.sh,
                      width: 0.9.sw,
                      decoration: BoxDecoration(
                          color: primarycolor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          "Move to audience".toUpperCase(),
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ],
                );
              });
        });
      },
    );
  }
}
