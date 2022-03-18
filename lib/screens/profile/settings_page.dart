import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/screens/manage_addresses/manage_addresses_screen.dart';
import 'package:fluttergistshop/screens/profile/orders_sceen.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  AuthController authController = Get.find<AuthController>();
  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Settings", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SizedBox(
          width: 0.9.sw,
          child: Column(
            children: [
              SizedBox(height: 0.03.sh,),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Twitter", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                          const Icon(
                              Icons.navigate_next, color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Instagram", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                          const Icon(
                            Icons.navigate_next, color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Facebook", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                          const Icon(
                            Icons.navigate_next, color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("LInkedIn", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                          const Icon(
                            Icons.navigate_next, color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0.03.sh,),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(OrdersScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Orders", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                          const Icon(
                            Icons.navigate_next, color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {
                        Get.to(ManageAddressesScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Addresses", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                          const Icon(
                            Icons.navigate_next, color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0.03.sh,),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("What's new", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                          const Icon(
                            Icons.navigate_next, color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("FAQ/Contact us", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                          const Icon(
                            Icons.navigate_next, color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Community guidelines", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                          const Icon(
                            Icons.navigate_next, color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0.03.sh,),
              Container(
                width: 0.9.sw,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                ),
                child: InkWell(
                  onTap: () {
                    Get.defaultDialog(onConfirm: () => authController.signOut(),
                        title: "Log out",
                    content: const Text("Are you sure you want to log out?"),
                    onCancel: () => Get.back(), textConfirm: "LogOut"
                    );
                  },
                  child: Text("LogOut", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
