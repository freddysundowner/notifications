import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/models/address.dart';
import 'package:fluttergistshop/services/helper.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/widgets/default_button.dart';
import 'package:get/get.dart';

import '../../../widgets/async_progress_dialog.dart';

class AddressDetailsForm extends StatelessWidget {
  final Address? addressToEdit;
  CheckOutController checkOutController = Get.find<CheckOutController>();


  AddressDetailsForm({this.addressToEdit, Key? key}) : super(key: key);

  static var _formKey = GlobalKey<FormState>();

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    print("AddressDetailsForm rebuilding");
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 30.h),
          buildReceiverField(),
          SizedBox(height: 30.h),
          buildAddressLine1Field(),
          SizedBox(height: 30.h),
          buildAddressLine2Field(),
          SizedBox(height: 30.h),
          buildCityField(),
          SizedBox(height: 30.h),
          buildStateField(),
          SizedBox(height: 30.h),
          buildPhoneField(),
          SizedBox(height: 30.h),
          DefaultButton(
            text: addressToEdit == null ? "Save" : "Update",
            press: addressToEdit == null
                ? () => saveNewAddressButtonCallback(context)
                : () => saveEditedAddressButtonCallback(context),
          ),
        ],
      ),
    );

    //return form;
  }

  Widget buildReceiverField() {
    return TextFormField(
      controller: checkOutController.addressReceiverFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Full Name of Receiver",
        labelText: "Receiver Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (checkOutController.addressReceiverFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildAddressLine1Field() {
    return TextFormField(
      controller: checkOutController.addressLine1FieldController,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: "Enter Address Line No. 1",
        labelText: "Address Line 1",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (checkOutController.addressLine1FieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildAddressLine2Field() {
    return TextFormField(
      controller: checkOutController.addressLine2FieldController,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: "Enter Address Line No. 2",
        labelText: "Address Line 2",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (checkOutController.addressLine2FieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCityField() {
    return TextFormField(
      controller: checkOutController.cityFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter City",
        labelText: "City",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (checkOutController.cityFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildStateField() {
    return TextFormField(
      controller: checkOutController.stateFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter State",
        labelText: "State",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (checkOutController.stateFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPhoneField() {
    return TextFormField(
      controller: checkOutController.phoneFieldController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter Phone Number",
        labelText: "Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (checkOutController.phoneFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        } else if (checkOutController.phoneFieldController.text.length != 10) {
          return "Only 10 Digits";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> saveNewAddressButtonCallback(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final Address newAddress = generateAddressObject();
      printOut("saveNewAddressButtonCallback ${newAddress.name}");
      var response;
      String snackbarMessage = "Saved successfully";
      try {
        response = UserAPI.addAddressForCurrentUser(newAddress);
        await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              response,
              message: const Text("Adding address"),
              onError: (e) {
                snackbarMessage = e.toString();
              },
            );
          },
        );

        var awaitedResponse = await response;
        if (await awaitedResponse["success"] == true) {
          Get.back();
          snackbarMessage = "Address saved successfully";
        } else {
          throw "Coundn't save the address due to unknown reason";
        }
      } catch (e, s) {
        printOut("Error saving address $e $s");
        snackbarMessage = "Something went wrong";
      } finally {
        Helper.showSnackBack(context, snackbarMessage);
      }
    }
  }

  Future<void> saveEditedAddressButtonCallback(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final Address newAddress = generateAddressObject(id: addressToEdit!.id);

      var response;
      String snackbarMessage = "updated successfully";
      try {
        response = UserAPI.updateAddressForCurrentUser(newAddress);
        await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              response,
              message: const Text("updating address"),
              onError: (e) {
                snackbarMessage = e.toString();
              },
            );
          },
        );
        var waitedResponse = await response;
        // print("response ${checkOutController.address.value!.name}");
        if (waitedResponse["success"] == true) {
          snackbarMessage = "Address updated successfully";

          //Update the address being viewed on checkout screen
          // checkOutController.address.value!.name =
          //     waitedResponse["data"]["name"];
          // checkOutController.address.value!.addrress1 =
          //     waitedResponse["data"]["addrress1"];
          // checkOutController.address.value!.addrress2 =
          //     waitedResponse["data"]["addrress2"];
          // checkOutController.address.value!.city =
          //     waitedResponse["data"]["city"];
          // checkOutController.address.value!.state =
          //     waitedResponse["data"]["state"];
          // checkOutController.address.value!.phone =
          //     waitedResponse["data"]["phone"];
          // checkOutController.address.refresh();
        } else {
          throw "Couldn't update address due to unknown reason";
        }
      } on FirebaseException catch (e) {
        printOut("Error editing address. Firebase exception $e ");
        snackbarMessage = "Something went wrong";
      } catch (e, s) {
        printOut("Error editing address $e $s");
        snackbarMessage = "Something went wrong";
      } finally {
        Get.back();
        Helper.showSnackBack(context, snackbarMessage);
      }
    }
  }

  Address generateAddressObject({String? id}) {
    return Address(
      id: id ?? "",
      name: checkOutController.addressReceiverFieldController.text,
      addrress1: checkOutController.addressLine1FieldController.text,
      addrress2: checkOutController.addressLine2FieldController.text,
      city: checkOutController.cityFieldController.text,
      state: checkOutController.stateFieldController.text,
      phone: checkOutController.phoneFieldController.text,
      userId: FirebaseAuth.instance.currentUser!.uid,
    );
  }
}
