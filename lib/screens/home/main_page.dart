import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/global.dart';
import 'package:fluttergistshop/screens/favorites/favorites.dart';
import 'package:fluttergistshop/screens/home/home_page.dart';
import 'package:fluttergistshop/screens/settings/settings_page.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  GlobalController _global = Get.find<GlobalController>();
  List<Widget> _pages = [SettingsPage(), HomePage(), Favorites()];
  _tabWidget(IconData icon, String title, Color color) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Icon(icon),
        SizedBox(
          height: 5,
        ),
        Text(title)
      ],
    );
  }

  static const double CreateButtonWidth = 38.0;

  Widget get customCreateIcon => Container(
      width: 45.0,
      height: 27.0,
      child: Stack(children: [
        Container(
            margin: EdgeInsets.only(left: 10.0),
            width: CreateButtonWidth,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 250, 45, 108),
                borderRadius: BorderRadius.circular(7.0))),
        Container(
            margin: EdgeInsets.only(right: 10.0),
            width: CreateButtonWidth,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 32, 211, 234),
                borderRadius: BorderRadius.circular(7.0))),
        Center(
            child: Container(
          height: double.infinity,
          width: CreateButtonWidth,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(7.0)),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 20.0,
          ),
        )),
      ]));
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _pages[_global.tabPosition.value],
        bottomNavigationBar: Container(
          height: 80,
          padding: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  _global.tabPosition.value = 1;
                },
                child: _tabWidget(Icons.home, "Home",
                    _global.tabPosition.value == 1 ? primarycolor : kTextColor),
              ),
              InkWell(
                onTap: () {
                  _global.tabPosition.value = 2;
                },
                child: _tabWidget(Icons.favorite, "Favorite",
                    _global.tabPosition.value == 2 ? primarycolor : kTextColor),
              ),
              Container(
                child: Icon(Icons.add),
              ),
              InkWell(
                onTap: () {
                  _global.tabPosition.value = 0;
                },
                child: _tabWidget(Icons.settings, "Settings",
                    _global.tabPosition.value == 0 ? primarycolor : kTextColor),
              ),
              InkWell(
                onTap: () {
                  _global.tabPosition.value = 3;
                },
                child: _tabWidget(Icons.add_shopping_cart_sharp, "Shop",
                    _global.tabPosition.value == 3 ? primarycolor : kTextColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
