import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/user_controller.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:get/get.dart';

final UserController _userController = Get.find<UserController>();
UserModel userModel = _userController.currentProfile.value;

showPremiumAlert(BuildContext context) {
  Dialog errorDialog = Dialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)), //this right here
    child: SizedBox(
      height: 0.3.sh,
      width: 0.3.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Upgrade account",
              style: TextStyle(color: Colors.black, fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 0.01.sh,
          ),
          InkWell(
            onTap: () async {
              Get.back();
              upgradeToPremium(context, userModel);
            },
            child: Container(
              alignment: FractionalOffset.bottomCenter,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Card(
                color: Colors.green,
                elevation: 30,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "Upgrade",
                        style: TextStyle(fontSize: 18.sp, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20.0)),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Dismiss!',
                style: TextStyle(color: Colors.red, fontSize: 18.0.sp),
              ))
        ],
      ),
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => errorDialog);
}

upgradeToPremium(BuildContext context, UserModel userModel) {
  showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0XFF0A0D2C),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * .8,
            margin: const EdgeInsets.only(top: 30),
            color: const Color(0XFF0A0D2C),
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "UPGRADE PREMIUM GISTER",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: const Color(0XFF00FFB0)),
                              ),
                              InkWell(
                                onTap: () => Get.back(),
                                child: const Icon(
                                  Icons.clear,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 0.01.sh),
                          Text(
                            "Upgrade now to get unlimited access to amazing next-level features of GistHouse",
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: const Color(0XFF00FFB0),
                                height: 1.3),
                          ),
                          SizedBox(height: 0.01.sh),
                          premiumFeature(
                              "Activate  Peer To Peer In-App Donations",
                              "Activate feature to Receive donations and gifts from your GistRooms, Followers and other Gisters"),
                          SizedBox(height: 0.01.sh),
                          premiumFeature(
                              "Activate Detailed Analytics Of Your GistRooms",
                              "Take the managing and marketing of your Rooms to next level with full business analytics of your rooms (attendee records, Room Length, Best Rooms in your clubs, moderator records, etc"),
                          SizedBox(height: 0.01.sh),
                          premiumFeature("Activate Room Advert/ Sponsorships",
                              "Monetize your rooms with ability to put sponsor names/tags at the top of your rooms."),
                          SizedBox(height: 0.01.sh),
                          premiumFeature("Activate Paid Rooms",
                              "Monetize your knowledge, followership and skills by running paid rooms right inside the app. "),
                          SizedBox(height: 0.01.sh),
                          premiumFeature(
                              "Access GistDeck For Desktop/Laptop Access",
                              "Get access to the desktop/laptop version of the app with extra features not found on the phone apps"),
                          SizedBox(height: 0.01.sh),
                          premiumFeature(
                              "Record and repurpose your room content",
                              "Access to gistdeck lets you record any room and you can use recordings in your podcasts and repurpose for other places"),
                        ])),
                SizedBox(height: 0.04.sh),
                InkWell(
                  onTap: () async {
                    Get.back();
                    await upgradeAccount(context);
                  },
                  child: Container(
                    width: 0.7.sw,
                    height: 0.1.sh,
                    decoration: BoxDecoration(
                        color: const Color(0XFF00FFB0),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 0.5,
                            blurRadius: 0.8,
                            offset: Offset(0, 5), // changes position of shadow
                          ),
                        ]),
                    child: Center(
                      child: Text(
                        "$PREMIUM_UPGRADE_COINS_AMOUNT GIST/Month \n \n UPGRADE NOW",
                        style: TextStyle(
                            color: const Color(0XFF0A0D2C),
                            fontFamily: "LucidaGrande",
                            fontSize: 16.sp),
                      ),
                    ),
                  ),
                )
              ]),
            ));
      });
}

Widget premiumFeature(String title, String body) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "LucidaGrande",
                  color: Colors.white,
                  height: 1.2)),
          const SizedBox(height: 10),
          Text(body,
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "LucidaGrande",
                  height: 1.5,
                  color: Colors.white)),
        ]),
  );
}

upgradeAccount(BuildContext context) async {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
        title: Obx(() {
          return Text(
            'Wallet Balance (${_userController.currentProfile.value.wallet})',
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          );
        }),
        actions: [
          CupertinoActionSheetAction(
            child: Text(
                'Amount to be deduted $gccurrency $PREMIUM_UPGRADE_COINS_AMOUNT',
                style: TextStyle(fontSize: 16.sp)),
            onPressed: () async {},
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Confirm Payment',
              style: TextStyle(fontSize: 16.sp, color: Colors.red)),
          onPressed: () {
            printOut("Upgrading account ${userModel.wallet!}");

            if (userModel.wallet! < PREMIUM_UPGRADE_COINS_AMOUNT) {
              Get.back();
              Get.snackbar("",
                  "You do not have enough GC to upgrade your account to premium",
                  backgroundColor: sc_snackBar, colorText: Colors.white);
            } else {
              Get.back();

              _userController.upgradeAccount();
            }
          },
        )),
  );
}
