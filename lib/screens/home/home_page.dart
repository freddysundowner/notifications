import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/screens/shops/shop_search_results.dart';
import 'package:fluttergistshop/screens/room/room_page.dart';
import 'package:fluttergistshop/utils/button.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../shops/my_products.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Get.to(() => ShopSearchResults());
            },
            child: const Icon(
              Ionicons.search,
              color: Colors.grey,
            ),
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
              InkWell(
                onTap: () {
                  showRoomTypeBottomSheet(context);
                },
                child: Container(
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
                  Get.to(const RoomPage());
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
                        ]),
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
                        SizedBox(
                          height: 0.01.sh,
                        ),
                        Divider(
                          color: Colors.grey[200],
                          height: 0.001.sh,
                        ),
                        SizedBox(
                          height: 0.01.sh,
                        ),
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
                                        color: Colors.white),
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

  Future<dynamic> showRoomTypeBottomSheet(BuildContext context) {
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        height: 0.01.sh,
                        width: 0.15.sw,
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "+  Add Title",
                            style:
                                TextStyle(color: Colors.red, fontSize: 16.sp),
                          )),
                      SizedBox(
                        height: 0.03.sh,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.black38),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Ionicons.earth,
                                    color: Theme.of(context).primaryColor,
                                    size: 80,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 0.01.sh,
                              ),
                              Text(
                                "Public Room",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 18.sp),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.black38),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Ionicons.shield_checkmark_outline,
                                    color: Theme.of(context).primaryColor,
                                    size: 80,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 0.01.sh,
                              ),
                              Text(
                                "Private Room",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 18.sp),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 0.04.sh,
                      ),
                      InkWell(
                          onTap: () {
                            showProductBottomSheet(context);
                          },
                          child: Button(
                            text: "Proceed",
                            width: 0.8.sw,
                          ))
                    ],
                  ),
                );
              });
        });
      },
    );
  }

  Future<dynamic> showProductBottomSheet(BuildContext context) {
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
              builder: (BuildContext productContext,
                  ScrollController scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(productContext).primaryColor,
                        height: 0.01.sh,
                        width: 0.15.sw,
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Text(
                        "Choose product",
                        style:
                            TextStyle(color: Colors.black87, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      SizedBox(
                        height: 0.35.sh,
                        child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // physics: ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.99,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Get.back();
                                  showChooseImagesBottomSheet(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Image.network(
                                            "http://52.43.151.113/public/img/61fb9094d59efb5046a99946.png",
                                            height: 0.1.sh,
                                            width: 0.2.sw,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Center(
                                          child: Text(
                                        "Product name",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.sp),
                                      ))
                                    ],
                                  ),
                                ),
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

  Future<dynamic> showChooseImagesBottomSheet(BuildContext context) {
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
              initialChildSize: 0.8,
              expand: false,
              builder: (BuildContext productContext,
                  ScrollController scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(productContext).primaryColor,
                        height: 0.01.sh,
                        width: 0.15.sw,
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      InkWell(
                        onTap: () {
                          showAddCoHostBottomSheet(context);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 0.01.sw,
                            ),
                            Text(
                              "Add a Co-host",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Text(
                        "Product A images",
                        style:
                            TextStyle(color: Colors.black87, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      SizedBox(
                        height: 0.35.sh,
                        child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // physics: ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.99,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Image.network(
                                          "http://52.43.151.113/public/img/61fb9094d59efb5046a99946.png",
                                          height: 0.1.sh,
                                          width: 0.2.sw,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 0.05.sh,
                            width: 0.3.sw,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 0.1,
                                    blurRadius: 0.5,
                                    offset: Offset(
                                        0, 5), // changes position of shadow
                                  ),
                                ]),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/wallet_icon.png",
                                  color: Colors.grey,
                                  width: 0.1.sw,
                                  height: 0.03.sh,
                                ),
                                SizedBox(
                                  height: 0.04.sh,
                                  child: const VerticalDivider(
                                    width: 0.001,
                                  ),
                                ),
                                SizedBox(
                                  width: 0.03.sw,
                                ),
                                Text(
                                  "20",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.03.sh,
                      ),
                      Button(text: "Finish", width: 0.9.sw)
                    ],
                  ),
                );
              });
        });
      },
    );
  }

  Future<dynamic> showAddCoHostBottomSheet(BuildContext context) {
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
              initialChildSize: 0.8,
              expand: false,
              builder: (BuildContext productContext,
                  ScrollController scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(productContext).primaryColor,
                        height: 0.01.sh,
                        width: 0.15.sw,
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Text(
                        "Add Co-hosts",
                        style:
                            TextStyle(color: Colors.black87, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      SizedBox(
                        height: 0.55.sh,
                        child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            // physics: ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.99,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                          child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                            "http://52.43.151.113/public/img/61fb9094d59efb5046a99946.png"),
                                      )),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Button(text: "Continue", width: 0.9.sw)
                    ],
                  ),
                );
              });
        });
      },
    );
  }
}
