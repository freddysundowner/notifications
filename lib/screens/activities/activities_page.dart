import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/activity_controller.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/activity_model.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/screens/profile/profile.dart';
import 'package:fluttergistshop/screens/settings/orders_sceen.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:get/get.dart';

class ActivitiesPage extends StatelessWidget {
  final ActivityController _activityController = Get.put(ActivityController());
  final UserController _userController = Get.find<UserController>();
  final RoomController _homeController = Get.find<RoomController>();

  ActivitiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Activities",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Obx(() {
        return _activityController.allActivitiesLoading.isFalse
            ? _activityController.allActivities.isNotEmpty
                ? ListView.builder(
                    itemCount: _activityController.allActivities.length,
                    itemBuilder: (context, index) {
                      ActivityModel activityModel = ActivityModel.fromJson(
                          _activityController.allActivities.elementAt(index));

                      return InkWell(
                        onTap: () {
                          if (activityModel.type == "ProfileScreen") {
                            _userController.getUserProfile(activityModel.actionkey!);
                            Get.to(Profile());
                          }  else if (activityModel.type == "RoomScreen") {
                            _homeController.currentRoom.value = RoomModel();
                            _homeController.joinRoom(activityModel.actionkey!);
                          } else if (activityModel.type == "OrderScreen") {
                            _userController.getUserOrders();
                            Get.to(OrdersScreen());
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              activityModel.imageurl != null
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          imageUrl + activityModel.imageurl!),
                                    )
                              : Container(),
                              SizedBox(
                                width: 0.04.sw,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          activityModel.name!,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16.sp),
                                        ),
                                        Text(activityModel.getTime()!,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.sp))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 0.01.sh,
                                    ),
                                    Text(
                                      activityModel.message!,
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 14.sp),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })
                : SizedBox(
                    height: 0.8.sh,
                    child: Center(
                      child: Text(
                        "No activities yet",
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    ),
                  )
            : SizedBox(
          height: 0.8.sh,
              child: const Center(
                child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
              ),
            );
      }),
    );
  }
}
