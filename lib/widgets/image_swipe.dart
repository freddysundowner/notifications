import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/product_controller.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:get/get.dart';

class ImageSwipe extends StatelessWidget {
  List imageList = [];
  ProductController productController = Get.find<ProductController>();
  ImageSwipe({required this.imageList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0.h,
      child: Stack(
        children: [
          PageView(
            onPageChanged: (num) {
              productController.selectedPage.value = num;
            },
            children: [
              if (imageList.length == 0)
                Container(
                  child: Image.asset(imageplaceholder),
                ),
              if (imageList.length > 0)
                for (var i = 0; i < imageList.length; i++)
                  Container(
                    child: CachedNetworkImage(
                      imageUrl: "${imageList[i]}",
                      imageBuilder: (context, imageProvider) => Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        size: 80,
                      ),
                    ),
                  )
            ],
          ),
          if (imageList.length > 0)
            Positioned(
              bottom: 20.0,
              left: 0,
              right: 0,
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i <= imageList.length; i++)
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          margin: EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          width: productController.selectedPage.value == i
                              ? 35.0
                              : 10.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.0)),
                        )
                    ],
                  )),
            )
        ],
      ),
    );
  }
}
