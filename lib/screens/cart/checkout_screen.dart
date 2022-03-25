import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/checkout_controller.dart';
import 'package:fluttergistshop/models/address.dart';
import 'package:fluttergistshop/models/checkout.dart';
import 'package:fluttergistshop/screens/cart/checkout_card.dart';
import 'package:fluttergistshop/screens/edit_address/edit_address_screen.dart';
import 'package:fluttergistshop/screens/manage_addresses/components/address_box.dart';
import 'package:fluttergistshop/screens/manage_addresses/components/address_short_details_card.dart';
import 'package:fluttergistshop/screens/manage_addresses/manage_addresses_screen.dart';
import 'package:fluttergistshop/screens/products/full_product.dart';
import 'package:fluttergistshop/screens/shops/components/product_short_detail_card.dart';
import 'package:fluttergistshop/services/helper.dart';
import 'package:fluttergistshop/services/notification_api.dart';
import 'package:fluttergistshop/services/orders_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:fluttergistshop/widgets/widgets.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class CheckOut extends StatelessWidget {
  CheckOutController checkOutController = Get.find<CheckOutController>();
  final AuthController authController = Get.find<AuthController>();
  CheckOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        checkOutController.product.value = null;
        checkOutController.qty.value = 0;
        checkOutController.selectetedvariationvalue.value = "";
        return true;
      },
      child: Scaffold(
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
                        "Your Cart",
                        style: headingStyle,
                      ),
                      SizedBox(height: 20.h),
                      buildCartItemsList(context),
                      SizedBox(height: 10.h),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageAddressesScreen(),
                            ),
                          );
                        },
                        child: Obx(() => Text(
                              checkOutController.address.value == null
                                  ? "Select Address"
                                  : "Change Address",
                              style: TextStyle(color: primarycolor),
                            )),
                      ),
                      SizedBox(height: 20.h),
                      Obx(() => checkOutController.address.value != null
                          ? buildAddressItemCard(
                              checkOutController.address.value!, context)
                          : Text("")),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> deleteButtonCallback(
      BuildContext context, String addressId) async {
    final confirmDeletion = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to remove this Address ?"),
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
      checkOutController.address.value = null;
      return true;
    }
    //   bool status = false;
    //   String snackbarMessage;
    //   try {
    //     status =
    //         await UserDatabaseHelper().deleteAddressForCurrentUser(addressId);
    //     if (status == true) {
    //       snackbarMessage = "Address deleted successfully";
    //     } else {
    //       throw "Coulnd't delete address due to unknown reason";
    //     }
    //   } on FirebaseException catch (e) {
    //     Logger().w("Firebase Exception: $e");
    //     snackbarMessage = "Something went wrong";
    //   } catch (e) {
    //     Logger().w("Unknown Exception: $e");
    //     snackbarMessage = e.toString();
    //   } finally {
    //     Logger().i(snackbarMessage);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(snackbarMessage),
    //       ),
    //     );
    //   }
    //   await refreshPage();
    //   return status;
    // }
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
          onTap: () async {
            await addressItemTapCallback(address, context);
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

  Future<void> refreshPage() {
    return Future<void>.value();
  }

  void _settingModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return CheckOutCard(
            onCheckoutPressed: () => checkoutButtonCallback(context),
          );
        });
  }

  Widget buildCartItemsList(BuildContext context) {
    checkOutController.ordertotal.value =
        checkOutController.product.value!.price!;
    return Column(
      children: [
        DefaultButton(
          text: "Proceed to Payment >>",
          press: () {
            if (checkOutController.address.value == null) {
              const GetSnackBar(message: "Pick address first").show();
            } else {
              _settingModalBottomSheet(context);
            }
          },
        ),
        SizedBox(height: 20.h),
        Container(
          padding: EdgeInsets.only(
            bottom: 4,
            top: 4,
            right: 4,
          ),
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: kTextColor.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 8,
                child: ProductShortDetailCard(
                  product: checkOutController.product.value,
                  onPressed: () {
                    Get.to(() => FullProduct(
                          product: checkOutController.product.value!,
                        ));
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: kTextColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.arrow_drop_up,
                          color: kTextColor,
                        ),
                        onTap: () async {
                          printOut(checkOutController.qty);
                          if (checkOutController.qty.value + 1 <=
                              checkOutController.product.value!.quantity!) {
                            checkOutController.qty.value += 1;
                            checkOutController.ordertotal.value =
                                checkOutController.qty.value *
                                    checkOutController.product.value!.price!;
                          } else {
                            Helper.showSnackBack(context, "not enough in stock",
                                color: Colors.red);
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      Obx(() => Text(
                            checkOutController.qty.value.toString(),
                            style: TextStyle(
                              color: primarycolor,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          )),
                      SizedBox(height: 8),
                      InkWell(
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: kTextColor,
                        ),
                        onTap: () async {
                          if (checkOutController.qty.value - 1 > 0) {
                            checkOutController.qty.value -= 1;
                            checkOutController.ordertotal.value =
                                checkOutController.qty.value *
                                    checkOutController.product.value!.price!;
                          } else {
                            Helper.showSnackBack(
                                context, "You cant buy 0 products",
                                color: Colors.red);
                          }
                          // await arrowDownCallback(cartItemId);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> checkoutButtonCallback(BuildContext context) async {
    if (authController.currentuser!.wallet! <= 0) {
      await showConfirmationDialog(
        context,
        "You don't have enough $currencyName to complete this order",
      );
      return;
    }
    print(authController.currentuser!.wallet);
    final confirmation = await showConfirmationDialog(
      context,
      "Are you sure you want to place the order?",
    );
    if (confirmation == false) {
      return;
    }

    Order order = Order(
        shippingId: checkOutController.address.value!.id,
        productId: checkOutController.product.value!.id!,
        shopId: checkOutController.product.value!.shopId!.id.toString(),
        subTotal: checkOutController.ordertotal.value.toString(),
        tax: checkOutController.tax.value.toString(),
        shippingFee: checkOutController.shipping.value.toString(),
        quantity: int.parse(checkOutController.qty.value.toString()),
        productOwnerId:
            checkOutController.product.value!.ownerId!.id.toString());
    // Checkout checkout = new Checkout(order: order);
    // checkOutController.checkout.value = checkOutController.checkout.value.
    final orderFuture = OrderApi.checkOut(order);
    orderFuture.then((orderedProductsUid) async {
      Get.back();
      if (orderedProductsUid != null) {
        String snackbarMessage = "Products ordered Successfully";
        try {
          await NotificationApi().sendNotification(
              [checkOutController.product.value!.ownerId!.id],
              "New Order",
              "Your product ${checkOutController.product.value!.name} just got ordered",
              "OrderScreen",
              FirebaseAuth.instance.currentUser!.uid);
        } catch (e) {
          snackbarMessage = e.toString();
        } finally {
          Helper.showSnackBack(context, snackbarMessage);
          Get.back();
        }
      } else {
        throw "Something went wrong while clearing cart";
      }
    }).catchError((e) {
      Helper.showSnackBack(context, "Something went wrong", color: Colors.red);
    });
    await showDialog(
      context: context,
      builder: (context) {
        return AsyncProgressDialog(
          orderFuture,
          message: Text("Placing the Order"),
        );
      },
    );
    await refreshPage();
  }
}
