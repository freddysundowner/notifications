import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/event_model.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/screens/home/create_room.dart';
import 'package:fluttergistshop/screens/profile/profile.dart';
import 'package:fluttergistshop/screens/room/upcomingRooms/new.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:fluttergistshop/widgets/default_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpcomingEvents extends StatelessWidget {
  UpcomingEvents({Key? key}) : super(key: key);
  RoomController roomController = Get.find<RoomController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Obx(
          () => Row(
            children: [
              Expanded(
                child: Container(
                    child: InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                          title: Text('What would you like to see?'),
                          actions: [
                            CupertinoActionSheetAction(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: const Text('Upcoming For You',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  if (homeController.selectedEvents.value ==
                                      "all")
                                    Icon(
                                      Icons.check,
                                      color: Colors.blue,
                                    )
                                ],
                              ),
                              onPressed: () {
                                homeController.selectedEvents.value = "all";
                                homeController.fetchEvents();
                                Navigator.pop(context);
                              },
                              isDefaultAction: true,
                            ),
                            CupertinoActionSheetAction(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: const Text('My Events',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  if (homeController.selectedEvents.value ==
                                      "mine")
                                    Icon(
                                      Icons.check,
                                      color: Colors.blue,
                                    )
                                ],
                              ),
                              onPressed: () {
                                homeController.selectedEvents.value = "mine";
                                homeController.fetchMyEvents();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: Text(
                              'Cancel',
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        homeController.selectedEvents.value == "mine"
                            ? "MY EVENTS"
                            : "UPCOMING FOR YOU",
                        style: TextStyle(fontSize: 17),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 20,
                      )
                    ],
                  ),
                )),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  CupertinoIcons.calendar_badge_plus,
                  size: 25,
                  color: primarycolor,
                ),
                onPressed: () {
                  Get.to(() => NewEventUpcoming());
                },
              )
            ],
          ),
        )),
        body: GetX<RoomController>(initState: (_) async {
          homeController.eventsList.value =
              await RoomController().fetchEvents();
        }, builder: (_) {
          List<EventModel> rooms = homeController.eventsList
              .map((element) => EventModel.fromJson(element))
              .toList();
          if (homeController.isLoading.isTrue) {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListView(
            children: rooms
                .map((element) => Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200],
                      ),
                      child: InkWell(
                        onTap: () {
                          upcomingEventBoottomSheet(context, element);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_date(element.eventDate),
                                    style: TextStyle(
                                        fontSize: 12.sp, color: primarycolor)),
                                if (element.ownerId!.id ==
                                    Get.find<AuthController>()
                                        .usermodel
                                        .value!
                                        .id)
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => NewEventUpcoming(
                                            roomModel: element,
                                          ));
                                    },
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(color: primarycolor),
                                    ),
                                  )
                              ],
                            ),
                            Text(
                              element.title!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.sp),
                            ),
                            Divider(),
                            Wrap(
                              children: List.generate(
                                  element.invitedhostIds!.length,
                                  (i) => Text(
                                        element.invitedhostIds![i].firstName! +
                                            " " +
                                            element
                                                .invitedhostIds![i].lastName! +
                                            ", ",
                                        style: TextStyle(
                                            fontSize: 13, color: primarycolor),
                                        overflow: TextOverflow.ellipsis,
                                      )).toList(),
                            ),
                            Wrap(
                              children: List.generate(
                                  element.invitedhostIds!.length,
                                  (i) => InkWell(
                                        onTap: () {
                                          Get.find<UserController>()
                                              .getUserProfile(element
                                                  .invitedhostIds![i].id!);
                                          Get.to(() => Profile());
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: element
                                              .invitedhostIds![i].profilePhoto!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons
                                                .supervised_user_circle_rounded,
                                            size: 40,
                                          ),
                                        ),
                                      )).toList(),
                            ),
                            Text(
                              element.description!,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          );
        }));
  }

  Future<dynamic> upcomingEventBoottomSheet(
      BuildContext context, EventModel element) {
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
        print("DraggableScrollableSheet 1");
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return DraggableScrollableSheet(
              initialChildSize: 0.3,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 10, bottom: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        element.title!,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Wrap(
                        children: [
                          Text(
                            "W/",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: primarycolor),
                          ),
                          ...element.invitedhostIds!
                              .map((e) => Text(
                                    "${e.firstName} ${e.lastName}, ",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: primarycolor),
                                  ))
                              .toList(),
                          Text(
                            element.description!,
                            style: TextStyle(fontSize: 16, color: primarycolor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                Icon(
                                  CupertinoIcons.share,
                                  size: 25,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Share",
                                  style: TextStyle(color: primarycolor),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                Icon(
                                  CupertinoIcons.doc_on_clipboard,
                                  size: 25,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Copy Link",
                                  style: TextStyle(color: primarycolor),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      DefaultButton(
                          text: "Go Live",
                          press: () {
                            roomController.roomHosts.value = element
                                .invitedhostIds!
                                .map((e) => UserModel(
                                    profilePhoto: e.profilePhoto,
                                    bio: e.bio,
                                    id: e.id,
                                    firstName: e.firstName,
                                    lastName: e.lastName,
                                    userName: e.userName,
                                    email: e.email))
                                .toList();
                            roomController.roomTitleController.text =
                                element.title!;
                            roomController.newRoomType.value =
                                element.roomType!;
                            roomController.roomPickedProduct.value =
                                element.productIds![0];

                            homeController.createRoom();
                          })
                    ],
                  ),
                );
              });
        });
      },
    );
  }

  _date(date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    print("today  $today");
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final dateToCheck = DateTime.fromMillisecondsSinceEpoch(date);
    final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day,
        dateToCheck.hour, dateToCheck.minute);
    final aDatee =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    var formatter = new DateFormat('hh:mm a');
    String when = "";
    if (aDatee == today) {
      when = "Today, ${formatter.format(dateToCheck).toString()}";
    } else if (aDatee == tomorrow) {
      when = "Tomorrow, ${formatter.format(dateToCheck).toString()}";
    } else {
      var formatter = new DateFormat('MMMM dd, yyyy, hh:mm a');

      String checkInTimeIsoString = formatter.format(aDate).toString();

      when = checkInTimeIsoString;
    }
    return when;
  }
}
