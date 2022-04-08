import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/chat_controller.dart';
import 'package:fluttergistshop/controllers/global.dart';
import 'package:fluttergistshop/controllers/room_controller.dart';
import 'package:fluttergistshop/controllers/shop_controller.dart';
import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/screens/chats/all_chats_page.dart';
import 'package:fluttergistshop/screens/favorites/favorites.dart';
import 'package:fluttergistshop/screens/home/create_room.dart';
import 'package:fluttergistshop/screens/home/home_page.dart';
import 'package:fluttergistshop/screens/settings/settings_page.dart';
import 'package:fluttergistshop/screens/shops/add_edit_shop.dart';
import 'package:fluttergistshop/screens/shops/shop_view.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  GlobalController _global = Get.find<GlobalController>();
  AuthController authController = Get.find<AuthController>();

  final RoomController _homeController = Get.put(RoomController());
  ShopController shopController = Get.find<ShopController>();
  final ChatController _chatController = Get.put(ChatController());

  OwnerId currentUser = OwnerId(
      id: Get.find<AuthController>().usermodel.value!.id,
      bio: Get.find<AuthController>().usermodel.value!.bio,
      email: Get.find<AuthController>().usermodel.value!.email,
      firstName: Get.find<AuthController>().usermodel.value!.firstName,
      lastName: Get.find<AuthController>().usermodel.value!.lastName,
      userName: Get.find<AuthController>().usermodel.value!.userName,
      profilePhoto: Get.find<AuthController>().usermodel.value!.profilePhoto);

  final List<Widget> _pages = [
    HomePage(),
    Favorites(),
    AllChatsPage(),
    SettingsPage()
  ];
  _tabWidget(Widget icon, String title, Color color) {
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        icon,
        SizedBox(
          height: 2.h,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 12.sp),
        )
      ],
    );
  }

  static const double CreateButtonWidth = 38.0;

  Widget get customCreateIcon => Container(
      width: 45.0,
      height: 27.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFFF05A22),
          style: BorderStyle.solid,
          width: 1.0,
        ),
        color: Colors.black,
      ),
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 20.0,
      ));

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _pages[_global.tabPosition.value],
        bottomNavigationBar: Container(
          height: 80,
          padding: EdgeInsets.only(bottom: 20, right: 10, left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  _global.tabPosition.value = 0;
                },
                child: _tabWidget(
                    Icon(
                      Icons.home,
                      color: _global.tabPosition.value == 0
                          ? primarycolor
                          : kTextColor,
                    ),
                    "Home",
                    _global.tabPosition.value == 0 ? primarycolor : kTextColor),
              ),
              InkWell(
                onTap: () {
                  _global.tabPosition.value = 1;
                },
                child: _tabWidget(
                    Icon(
                      Icons.favorite,
                      color: _global.tabPosition.value == 1
                          ? primarycolor
                          : kTextColor,
                    ),
                    "Favorite",
                    _global.tabPosition.value == 1 ? primarycolor : kTextColor),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: new Icon(Icons.live_tv),
                              title: InkWell(
                                onTap: () async {
                                  if (Get.find<AuthController>()
                                              .usermodel
                                              .value!
                                              .shopId !=
                                          null &&
                                      Get.find<AuthController>()
                                          .usermodel
                                          .value!
                                          .shopId!
                                          .open!) {
                                    _homeController.newRoomTitle.value = " ";
                                    _homeController.newRoomType.value =
                                        "public";
                                    showRoomTypeBottomSheet(context);
                                  } else {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Confirmation"),
                                          content: Text(
                                              "${Get.find<AuthController>().usermodel.value!.shopId == null ? "You do not have a shop, do you want to create one?" : " Your shop is closed , Do you want to  open it?"} "),
                                          actions: [
                                            FlatButton(
                                              child: Text("Yes"),
                                              onPressed: () async {
                                                Navigator.pop(context, false);
                                                if (Get.find<AuthController>()
                                                        .usermodel
                                                        .value!
                                                        .shopId ==
                                                    null) {
                                                  Get.to(() => NewShop());
                                                }
                                                if (Get.find<AuthController>()
                                                        .usermodel
                                                        .value!
                                                        .shopId!
                                                        .open! ==
                                                    false) {
                                                  Get.find<ShopController>()
                                                          .currentShop
                                                          .value =
                                                      Get.find<AuthController>()
                                                          .usermodel
                                                          .value!
                                                          .shopId!;
                                                  Get.to(() => ShopView());
                                                }
                                              },
                                            ),
                                            FlatButton(
                                              child: Text("No"),
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Text(
                                  "Go Live",
                                  style: TextStyle(
                                      fontSize: 18.sp, color: Colors.black),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            if (authController.currentuser?.shopId?.id != null)
                              ListTile(
                                leading: new Icon(Icons.shopping_cart),
                                title: new Text(
                                  'My Shop',
                                  style: TextStyle(
                                      fontSize: 18.sp, color: Colors.black),
                                ),
                                onTap: () {
                                  shopController.currentShop.value =
                                      authController.currentuser!.shopId!;
                                  Get.to(() => ShopView());
                                },
                              ),
                            if (authController.currentuser?.shopId?.id == null)
                              ListTile(
                                leading: new Icon(Icons.shopping_cart),
                                title: new Text(
                                  "Create a Shop",
                                  style: TextStyle(
                                      fontSize: 18.sp, color: Colors.black),
                                ),
                                onTap: () {
                                  Get.to(() => NewShop());
                                },
                              ),
                          ],
                        );
                      });
                },
                child: Container(
                  width: 50,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  child: Icon(Icons.add),
                ),
              ),
              InkWell(
                onTap: () {
                  _global.tabPosition.value = 2;
                },
                child: _tabWidget(Obx(() {
                  return Stack(
                    children: [
                      Icon(
                        Ionicons.chatbox,
                        color: _global.tabPosition.value == 2
                            ? primarycolor
                            : kTextColor,
                      ),
                      if (_chatController.unReadChats > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Container(
                            height: 0.03.sh,
                            width: 0.04.sw,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                                child: Text(
                              _chatController.unReadChats.toString(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.sp),
                            )),
                          ),
                        )
                    ],
                  );
                }), "Messages",
                    _global.tabPosition.value == 2 ? primarycolor : kTextColor),
              ),
              InkWell(
                onTap: () {
                  _global.tabPosition.value = 3;
                },
                child: _tabWidget(
                    Icon(
                      Icons.settings,
                      color: _global.tabPosition.value == 3
                          ? primarycolor
                          : kTextColor,
                    ),
                    "Settings",
                    _global.tabPosition.value == 3 ? primarycolor : kTextColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
