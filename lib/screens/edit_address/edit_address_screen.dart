import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/models/address.dart';
import 'package:fluttergistshop/screens/edit_address/components/address_details_form.dart';
import 'package:fluttergistshop/services/api_calls.dart';
import 'package:fluttergistshop/utils/constants.dart';

class EditAddressScreen extends StatelessWidget {
  final Address? address;

  const EditAddressScreen({Key? key, this.address}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    "Address Details",
                    style: headingStyle,
                  ),
                  SizedBox(height: 10.h),
                  AddressDetailsForm(
                    addressToEdit: address,
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
