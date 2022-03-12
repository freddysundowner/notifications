import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

Future<dynamic> showInviteFriendsBottomSheet(BuildContext context) {
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
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Ionicons.people,
                              color: Colors.grey,
                            ),
                            Text(
                              "Invite friends",
                              style:
                              TextStyle(color: Colors.grey, fontSize: 14.sp),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 0.03.sh,
                        ),
                        SizedBox(
                          height: 0.4.sh,
                          child: GridView.builder(
                              shrinkWrap: true,
                              // physics: ScrollPhysics(),
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 0.9,
                              ),
                              itemCount: 19,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    const CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "http://52.43.151.113/public/img/61fb9094d59efb5046a99946.png"),
                                      radius: 30,
                                    ),
                                    SizedBox(
                                      height: 0.01.sh,
                                    ),
                                    Text(
                                      "User name",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14.sp),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                });
          });
    },
  );
}
