import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/product.dart';

import '../../../utils/utils.dart';

class ProductShortDetailCard extends StatelessWidget {
  final Product? product;
  final VoidCallback? onPressed;
  const ProductShortDetailCard({
    Key? key,
    @required this.product,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed,
      child: Row(
        children: [
          SizedBox(
            width: 88.w,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: product!.images.length > 0
                    ? Image.network(
                        product!.images[0],
                        fit: BoxFit.contain,
                      )
                    : Text("No Image"),
              ),
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product!.name,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: kTextColor,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                      text: "${product!.htmlPrice(product!.price)}    ",
                      style: TextStyle(
                        color: primarycolor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: "${product!.htmlPrice(product!.price)}",
                          style: TextStyle(
                            color: kTextColor,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.normal,
                            fontSize: 11,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
