import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/screens/room/room_page.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          leading: const Icon(
            Ionicons.search,
            color: Colors.grey,
          ),
          actions: [
            Image.asset(
              "assets/icons/wallet_icon.png",
              color: Colors.grey,
              width: 0.06.sw,
              height: 0.005.sh,
            ),
            SizedBox(
              width: 0.05.sw,
            ),
             const Icon(
              Ionicons.notifications,
              color: Colors.grey,
              size: 30,
            ),
            SizedBox(
              width: 0.05.sw,
            ),
            SizedBox(
              height: 0.005.sh,
              width: 0.07.sw,
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "http://52.43.151.113/public/img/61fb9094d59efb5046a99946.png"),
              ),
            ),
            SizedBox(
              width: 0.02.sw,
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 0.6.sw,
                height: 0.07.sh,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor),
                child: Center(
                  child: Text(
                    "Create a room",
                    style: TextStyle(fontSize: 18.sp, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 0.1.sw,
              ),
              const Icon(
                Ionicons.chatbox_outline,
                color: Colors.grey,
                size: 35,
              )
            ],
          ),
        ),
        body: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.to(RoomPage());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 0.1,
                        blurRadius: 0.5,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                      ]
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "1",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(width: 0.006.sw),
                            const Icon(
                              Ionicons.people,
                              color: Colors.grey,
                              size: 20,
                            ),
                            SizedBox(width: 0.03.sw),
                            const Text(
                              "2",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(width: 0.006.sw),
                            const Icon(
                              Ionicons.chatbubble_outline,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.1.sh,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "http://52.43.151.113/public/img/61fb9094d59efb5046a99946.png"),
                                    ));
                              }),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "trial",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: 0.01.sh,),
                        Divider(
                          color: Colors.grey[200],
                          height: 0.001.sh,
                        ),
                        SizedBox(height: 0.01.sh,),
                        SizedBox(
                          height: 0.12.sh,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white
                                    ),
                                    child: Center(
                                      child: Image.network(
                                        "http://52.43.151.113/public/img/61fb9094d59efb5046a99946.png",
                                        height: 0.08.sh,
                                        width: 0.12.sw,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
