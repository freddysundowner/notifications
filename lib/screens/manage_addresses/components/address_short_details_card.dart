import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/address.dart';
import 'package:fluttergistshop/utils/utils.dart';

class AddressShortDetailsCard extends StatelessWidget {
  final Address address;
  final Function onTap;

  const AddressShortDetailsCard(
      {Key? key, required this.address, required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: SizedBox(
        width: double.infinity,
        height: 0.22.sh,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: kTextColor.withOpacity(0.24),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    address.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: kTextColor.withOpacity(0.24)),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      address.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      address.addrress1,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      address.state,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "City: ${address.city}",
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Phone: ${address.phone}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
