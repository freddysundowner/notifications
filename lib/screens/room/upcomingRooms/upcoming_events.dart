import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/event_model.dart';
import 'package:fluttergistshop/screens/home/create_room.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/screens/profile/profile.dart';
import 'package:fluttergistshop/screens/room/upcomingRooms/new.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:fluttergistshop/widgets/default_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import '../../../services/dynamic_link_services.dart';
import '../../../services/helper.dart';

class UpcomingEvents extends StatelessWidget {
  EventModel? roomModel;
  UpcomingEvents({Key? key, this.roomModel}) : super(key: key);
  RoomController roomController = Get.find<RoomController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Obx(
        () => Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                        title: const Text('What would you like to see?'),
                        actions: [
                          CupertinoActionSheetAction(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text('Upcoming For You',
                                      style: TextStyle(fontSize: 16.sp)),
                                ),
                                if (homeController.selectedEvents.value ==
                                    "all")
                                  const Icon(
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
                                  child: Text('My Events',
                                      style: TextStyle(fontSize: 16.sp)),
                                ),
                                if (homeController.selectedEvents.value ==
                                    "mine")
                                  const Icon(
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
                          child: const Text(
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
                      style: TextStyle(fontSize: 17.sp),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
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
      body: RefreshIndicator(
        onRefresh: () {
          if (homeController.selectedEvents.value == "mine") {
            return roomController.fetchMyEvents();
          } else {
            return roomController.fetchEvents();
          }
        },
        child: GetX<RoomController>(initState: (_) async {
          homeController.eventsList.value =
              await RoomController().fetchEvents();
        }, builder: (_) {
          List<EventModel> rooms = homeController.eventsList
              .map((element) => EventModel.fromJson(element))
              .toList();
          if (homeController.isLoading.isTrue) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (homeController.eventsList.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No Events to show",
                  style: regularDarkText,
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    CupertinoIcons.calendar_badge_plus,
                    size: 80,
                    color: primarycolor,
                  ),
                  onPressed: () {
                    Get.to(() => NewEventUpcoming());
                  },
                )
              ],
            ));
          }
          return ListView(
            children: rooms
                .map((event) => Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200],
                      ),
                      child: InkWell(
                        onTap: () {
                          upcomingEventBottomSheet(context, event);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_date(event.eventDate),
                                    style: TextStyle(
                                        fontSize: 12.sp, color: primarycolor)),
                                if (event.ownerId!.id ==
                                    Get.find<AuthController>()
                                        .usermodel
                                        .value!
                                        .id)
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => NewEventUpcoming(
                                            roomModel: event,
                                          ));
                                    },
                                    child: const Text(
                                      "Edit",
                                      style: TextStyle(color: primarycolor),
                                    ),
                                  ),

                                // if (element.ownerId!.id !=
                                //     Get.find<AuthController>().usermodel.value!.id!)
                                  Obx(() {
                                      return InkWell(
                                        onTap: () {
                                          roomController.addRemoveToBeNotified(event);
                                         // Get.back();

                                         // roomController.fetchEvents();
                                        },
                                        child: Icon(
                                          CupertinoIcons.bell,
                                          size: 25,
                                          color: EventModel.fromJson(roomController.eventsList.elementAt(roomController.eventsList.indexWhere(
                                                  (element) =>
                                              EventModel.fromJson(element).id == event.id)))
                                              .toBeNotified!.contains(
                                              Get.find<AuthController>()
                                                  .usermodel
                                                  .value!
                                                  .id!)
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      );
                                    }
                                  ),
                              ],
                            ),
                            Text(
                              event.title!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.sp),
                            ),
                            const Divider(),
                            Wrap(
                              children: List.generate(
                                  event.invitedhostIds!.length,
                                  (i) => Text(
                                        event.invitedhostIds![i].firstName! +
                                            " " +
                                            event
                                                .invitedhostIds![i].lastName! +
                                            ", ",
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            color: primarycolor),
                                        overflow: TextOverflow.ellipsis,
                                      )).toList(),
                            ),
                            Wrap(
                              children: List.generate(
                                  event.invitedhostIds!.length,
                                  (i) => InkWell(
                                        onTap: () {
                                          Get.find<UserController>()
                                              .getUserProfile(event
                                                  .invitedhostIds![i].id!);
                                          Get.to(() => Profile());
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: event
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
                              event.description!,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          );
        }),
      ),
    );
  }

  Future<dynamic> upcomingEventBottomSheet(
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

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return DraggableScrollableSheet(
              initialChildSize: 0.6,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            element.title!,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          if (element.ownerId!.id ==
                              Get.find<AuthController>().usermodel.value!.id!)
                            InkWell(
                              onTap: () {
                                roomController.deleteEvent(element.id!);
                              },
                              child: const Icon(
                                CupertinoIcons.delete,
                                size: 25,
                                color: Colors.red,
                              ),
                            ),

                          if (element.ownerId!.id !=
                              Get.find<AuthController>().usermodel.value!.id!)
                          InkWell(
                            onTap: () {
                              roomController.addRemoveToBeNotified(element);
                              Get.back();
                              roomController.fetchEvents();
                            },
                            child: Icon(
                              CupertinoIcons.bell,
                              size: 25,
                              color: element.toBeNotified!.contains(
                                      Get.find<AuthController>()
                                          .usermodel
                                          .value!
                                          .id!)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      Wrap(
                        children: [
                          const Text(
                            "W/",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: primarycolor),
                          ),
                          ...element.invitedhostIds!
                              .map((e) => Text(
                                    "${e.firstName} ${e.lastName}, ",
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: primarycolor),
                                  ))
                              .toList()
                        ],
                      ),
                      if (element.description!.isNotEmpty)
                        Text(
                          element.description!,
                        ),
                      const Divider(),
                      const Text("Product"),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() =>
                              FullProduct(product: element.productIds![0]));
                        },
                        child: ListTile(
                          minLeadingWidth: 0,
                          contentPadding: const EdgeInsets.all(0),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              element.productIds![0].images!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          element.productIds![0].images!.first,
                                      height: 0.1.sh,
                                      width: 0.2.sw,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )
                                  : Image.asset(
                                      "assets/icons/no_image.png",
                                      height: 0.1.sh,
                                      width: 0.2.sw,
                                      fit: BoxFit.fill,
                                    ),
                              SizedBox(
                                width: 0.03.sw,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    element.productIds![0].name!,
                                    style: TextStyle(fontSize: 13.sp),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Text(
                                    "GC " +
                                        element.productIds![0].price!
                                            .toString(),
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                  if (element
                                      .productIds![0].description!.isNotEmpty)
                                    Text(
                                      element.productIds![0].description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              roomController.shareSheetLoading.value = true;
                              DynamicLinkService()
                                  .createGroupJoinLink(element.id!, "event")
                                  .then(
                                      (value) async => await Share.share(value))
                                  .then((value) => roomController
                                      .shareSheetLoading.value = false);
                            },
                            child: Obx(() {
                              return Column(
                                children: [
                                  roomController.shareSheetLoading.isFalse
                                      ? const Icon(
                                          CupertinoIcons.share,
                                          size: 25,
                                          color: Colors.green,
                                        )
                                      : const CircularProgressIndicator(),
                                  SizedBox(
                                    height: 0.01.sh,
                                  ),
                                  const Text(
                                    "Share",
                                    style: TextStyle(color: primarycolor),
                                  )
                                ],
                              );
                            }),
                          ),
                          GestureDetector(
                            onTap: () {
                              roomController.shareLinkLoading.value = true;
                              DynamicLinkService()
                                  .createGroupJoinLink(element.id!, "event")
                                  .then((value) async {
                                Clipboard.setData(ClipboardData(text: value));
                                roomController.shareLinkLoading.value = false;
                              });
                              Get.back();
                              Helper.showSnackBack(
                                  context, "Link copied to clipboard");
                            },
                            child: Column(
                              children: [
                                roomController.shareLinkLoading.isFalse
                                    ? const Icon(
                                        CupertinoIcons.doc_on_clipboard,
                                        size: 25,
                                        color: Colors.green,
                                      )
                                    : const CircularProgressIndicator(),
                                SizedBox(
                                  height: 0.01.sh,
                                ),
                                const Text(
                                  "Copy Link",
                                  style: TextStyle(color: primarycolor),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      if (element.invitedhostIds!.indexWhere((element) =>
                              element.id ==
                              Get.find<AuthController>()
                                  .usermodel
                                  .value!
                                  .id!) !=
                          -1)
                        DefaultButton(
                            text:
                                element.token != null ? "Join Live" : "Go Live",
                            press: () {
                              if (element.token != null) {
                                roomController.joinRoom(element.id!);
                              } else {
                                roomController.createRoomFromEvent(element);
                              }
                            }),
                      if (element.invitedhostIds!.indexWhere((element) =>
                                  element.id ==
                                  Get.find<AuthController>()
                                      .usermodel
                                      .value!
                                      .id!) ==
                              -1 &&
                          element.token != null)
                        DefaultButton(
                            text: "Join Live",
                            press: () {
                              roomController.joinRoom(element.id!);
                            }),
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
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final dateToCheck = DateTime.fromMillisecondsSinceEpoch(date);
    final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day,
        dateToCheck.hour, dateToCheck.minute);
    final aDatee =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    var formatter = DateFormat('hh:mm a');
    String when = "";
    if (aDatee == today) {
      when = "Today, ${formatter.format(dateToCheck).toString()}";
    } else if (aDatee == tomorrow) {
      when = "Tomorrow, ${formatter.format(dateToCheck).toString()}";
    } else {
      var formatter = DateFormat('MMMM dd, yyyy, hh:mm a');

      String checkInTimeIsoString = formatter.format(aDate).toString();

      when = checkInTimeIsoString;
    }
    return when;
  }
}
