import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/models/address.dart';
import 'package:fluttergistshop/screens/edit_address/edit_address_screen.dart';
import 'package:fluttergistshop/screens/manage_addresses/components/address_short_details_card.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/widgets/nothingtoshow_container.dart';
import 'package:get/get.dart';
import '../../widgets/default_button.dart';
import 'components/address_box.dart';

class ManageAddressesScreen extends StatelessWidget {
  bool checkout = false;
  ManageAddressesScreen(this.checkout, {Key? key}) : super(key: key);

  CheckOutController checkOutController = Get.find<CheckOutController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshPage,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      "Manage Addresses",
                      style: headingStyle,
                    ),
                    Text(
                      "Swipe LEFT to Edit, Swipe RIGHT to Delete",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10.h),
                    DefaultButton(
                      text: "Add New Address",
                      press: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAddressScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: FutureBuilder<List<Address>>(
                        future: UserAPI.getAddressesFromUserId(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Address>? addresses = snapshot.data;
                            if (addresses!.length == 0) {
                              return Center(
                                child: NothingToShowContainer(
                                  iconPath: "assets/icons/add_location.svg",
                                  secondaryMessage: "Add your first Address",
                                ),
                              );
                            }
                            return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: addresses.length,
                                itemBuilder: (context, index) {
                                  return buildAddressItemCard(
                                      addresses[index], context);
                                });
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            final error = snapshot.error;
                          }
                          return Center(
                            child: NothingToShowContainer(
                              iconPath: "assets/icons/network_error.svg",
                              primaryMessage: "Something went wrong",
                              secondaryMessage: "Unable to connect to Database",
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    return Future<void>.value();
  }

  Future<bool> deleteButtonCallback(
      BuildContext context, String addressId) async {
    final confirmDeletion = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to delete this Address ?"),
          actions: [
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );

    if (confirmDeletion) {
      bool status = false;
      String snackbarMessage = "";
      try {
        status = await UserAPI.deleteAddressForCurrentUser(addressId);
        if (status == true) {
          snackbarMessage = "Address deleted successfully";
        } else {
          throw "Coulnd't delete address due to unknown reason";
        }
      } on FirebaseException catch (e) {
        snackbarMessage = "Something went wrong";
      } catch (e) {
        print(e.toString());
        snackbarMessage = e.toString();
      } finally {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
      await refreshPage();
      return status;
    }
    return false;
  }

  Future<bool> editButtonCallback(BuildContext context, Address address) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditAddressScreen(address: address)));
    await refreshPage();
    return false;
  }

  Future<void> addressItemTapCallback(
      Address address, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          title: AddressBox(
            address: address,
          ),
          titlePadding: EdgeInsets.zero,
        );
      },
    );
    await refreshPage();
  }

  Widget buildAddressItemCard(Address address, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Dismissible(
        key: Key(address.id),
        direction: DismissDirection.horizontal,
        background: buildDismissibleSecondaryBackground(),
        secondaryBackground: buildDismissiblePrimaryBackground(),
        dismissThresholds: {
          DismissDirection.endToStart: 0.65,
          DismissDirection.startToEnd: 0.65,
        },
        child: AddressShortDetailsCard(
          address: address,
          onTap: () {
            if (checkout) {
              checkOutController.address.value = address;
              Get.back();
            } else {
              editButtonCallback(context, address);
            }
          },
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            final status = await deleteButtonCallback(context, address.id);
            return status;
          } else if (direction == DismissDirection.endToStart) {
            final status = await editButtonCallback(context, address);
            return status;
          }
          return false;
        },
        onDismissed: (direction) async {
          await refreshPage();
        },
      ),
    );
  }

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDismissibleSecondaryBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
