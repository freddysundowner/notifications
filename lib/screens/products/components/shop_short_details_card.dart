import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/product.dart';

import '../../../utils/utils.dart';

class ShopShortDetailCard extends StatelessWidget {
  final Product? product;
  final VoidCallback? onPressed;
  const ShopShortDetailCard({
    Key? key,
    @required this.product,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          SizedBox(
            width: 0.22.sw,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: product!.images!.isNotEmpty
                    ? CachedNetworkImage(
                        errorWidget: (context, String, dynamic) => Image.asset(
                          imageplaceholder,
                          fit: BoxFit.contain,
                        ),
                        imageUrl: product!.images![0],
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        imageplaceholder,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
          SizedBox(width: 0.01.sw),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product!.name!,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                ),
              ),
              if (product!.description!.isNotEmpty)
                Text(
                  product!.description!.length > 30
                      ? product!.description!.substring(0, 30) + "..."
                      : product!.description.toString(),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: kTextColor,
                  ),
                  maxLines: 2,
                ),
              Text(
                "$currencySymbol${product!.price}    ",
                style: TextStyle(
                  color: secondaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
