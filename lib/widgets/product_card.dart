import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/styles.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final GestureTapCallback press;
  const ProductCard({
    Key? key,
    required this.product,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 0.35.sw,
        margin: const EdgeInsets.only(right: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kTextColor.withOpacity(0.15)),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: buildProductCardItems(product),
      ),
    );
  }

  Column buildProductCardItems(Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: product.images!.length == 0
              ? EdgeInsets.all(8.0)
              : EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Color(0XFFC9C9C9),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8), topLeft: Radius.circular(8))),
          child: product.images!.isEmpty
              ? Image.asset(
                  imageplaceholder,
                  fit: BoxFit.contain,
                  height: 0.16.sh,
                  width: double.infinity,
                )
              : Center(
                  child: CachedNetworkImage(
                    imageUrl: product.images![0],
                    imageBuilder: (context, imageProvider) => Container(
                      width: double.infinity,
                      height: 0.16.sh,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(
                      color: Colors.black,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      size: 120,
                    ),
                  ),
                ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${product.name}",
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text.rich(
                TextSpan(
                  text: "${product.htmlPrice(product.price).toString()}\n",
                  style: TextStyle(
                    color: primarycolor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                  children: [
                    TextSpan(
                      text: product.htmlPrice(product.discountPrice).toString(),
                      style: TextStyle(
                        color: kTextColor,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.normal,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
