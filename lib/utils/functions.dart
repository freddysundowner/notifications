import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/screens/home/create_room.dart';
import 'package:get/get.dart';

printOut(data) {
  if (!kDebugMode) {
    print(data);
  }
}

String convertTime(String time) {
  var convertedTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  var timeDifference =
      "${convertedTime.day}/${convertedTime.month}/${convertedTime.year}";

  var diff = DateTime.now().difference(convertedTime);

  if (diff.inMinutes < 1) {
    timeDifference = "now";
  } else if (diff.inHours < 1) {
    timeDifference = "${diff.inMinutes} minutes ago";
  } else if (diff.inHours <= 24) {
    timeDifference = "${diff.inHours} hours ago";
  } else if (diff.inHours <= 47) {
    timeDifference = "${diff.inDays} day ago";
  }

  return timeDifference;
}

String showActualTime(String time) {
  var convertedTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  var hour = convertedTime.hour.toString().length == 2
      ? convertedTime.hour
      : "0${convertedTime.hour}";
  var minute = convertedTime.minute.toString().length == 2
      ? convertedTime.minute
      : "0${convertedTime.minute}";

  var timeDifference = "$hour:$minute  "
      "${convertedTime.day}/${convertedTime.month}/${convertedTime.year}";

  return timeDifference;
}

Future<dynamic> showProductBottomSheet(BuildContext context) async {
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
                      style: TextStyle(color: Colors.black87, fontSize: 16.sp),
                    ),
                    SizedBox(
                      height: 0.01.sh,
                    ),
                    Obx(() {
                      return homeController.userProductsLoading.isFalse
                          ? SizedBox(
                              height: 0.35.sh,
                              child: homeController.userProducts.isNotEmpty
                                  ? GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      // physics: ScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemCount:
                                          homeController.userProducts.length,
                                      itemBuilder: (context, index) {
                                        Product product = Product.fromJson(
                                            homeController.userProducts
                                                .elementAt(index));

                                        return InkWell(
                                          onTap: () {
                                            Get.back();
                                            homeController.roomPickedProduct
                                                .value = product;

                                            showChooseImagesBottomSheet(
                                                context, product);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Center(
                                                    child: product
                                                            .images!.isNotEmpty
                                                        ? CachedNetworkImage(
                                                            imageUrl: product
                                                                .images!.first,
                                                            height: 0.1.sh,
                                                            width: 0.2.sw,
                                                            fit: BoxFit.fill,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CircularProgressIndicator(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          )
                                                        : Image.asset(
                                                            "assets/icons/no_image.png",
                                                            height: 0.1.sh,
                                                            width: 0.2.sw,
                                                            fit: BoxFit.fill,
                                                          ),
                                                  ),
                                                ),
                                                Center(
                                                    child: Text(
                                                  product.name!,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12.sp),
                                                ))
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : Text(
                                      "You have no products yet",
                                      style: TextStyle(
                                          fontSize: 16.sp, color: Colors.grey),
                                    ))
                          : const CircularProgressIndicator(
                              color: Colors.black,
                            );
                    }),
                  ],
                ),
              );
            });
      });
    },
  );
}
