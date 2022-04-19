import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/wallet_controller.dart';
import 'package:fluttergistshop/models/transaction_model.dart';
import 'package:fluttergistshop/models/user_model.dart';
import 'package:fluttergistshop/services/client.dart';
import 'package:fluttergistshop/services/end_points.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

import '../../widgets/widgets.dart';

class WalletPage extends StatelessWidget {
  AuthController authController = Get.find<AuthController>();
  final WalletController _walletController = Get.put(WalletController());

  WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wallet",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () => _walletController.getUserTransactions(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 0.9.sw,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "Wallet Balance:",
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                        Obx(() {
                          return Text(
                            "$gccurrency " +
                                authController.currentuser!.wallet!.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          );
                        }),
                        InkWell(
                          onTap: () {
                            withdrawGP(context, "send", gccurrency,
                                userModel: authController.currentuser!,
                                onButtonPressed: (type, amount) async {
                              print("oooooooook");
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.wallet_giftcard,
                                color: Colors.green,
                              ),
                              Text(
                                " Withdraw",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.03.sh,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recent Transactions",
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  )),
              SizedBox(
                height: 0.01.sh,
              ),
              Obx(() {
                return _walletController.moreTransactionsLoading.isTrue
                    ? Column(
                        children: [
                          const Center(
                              child: CircularProgressIndicator(
                            color: Colors.black,
                          )),
                          SizedBox(
                            height: 0.01.sh,
                          ),
                        ],
                      )
                    : Container();
              }),
              const Divider(),
              SizedBox(
                height: 0.01.sh,
              ),
              Obx(() {
                return SizedBox(
                    height: 0.57.sh,
                    child: _walletController.transactionsLoading.isFalse
                        ? _walletController.userTransaction.isNotEmpty
                            ? ListView.builder(
                                controller: _walletController
                                    .transactionScrollController,
                                itemCount:
                                    _walletController.userTransaction.length,
                                itemBuilder: (context, index) {
                                  TransactionModel transaction =
                                      TransactionModel.fromJson(
                                          _walletController.userTransaction
                                              .elementAt(index));
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        convertTime(
                                            transaction.date.toString()),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 12.sp),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${transaction.type == "gift" ? transaction.reason + " -- ${transaction.from!.firstName!}" : transaction.reason}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.sp),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            "$gccurrency ${transaction.deducting == true ? "-" : "+"}${transaction.amount}",
                                            style: TextStyle(
                                                color: transaction.deducting ==
                                                        true
                                                    ? Colors.red
                                                    : Colors.green,
                                                fontSize: 13.sp),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 0.02.sh,
                                      ),
                                      Divider()
                                    ],
                                  );
                                })
                            : Center(
                                child: Text(
                                  "You have no transactions yet",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.sp),
                                ),
                              )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ));
              })
            ],
          ),
        ),
      ),
    );
  }

  static withdrawGP(BuildContext context, String currency, String gccurrency,
      {Function? onButtonPressed, UserModel? userModel}) {
    var amountcontroller = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.9,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "How much GistPoints you want to withdraw? ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      controller: amountcontroller,
                                      autofocus: true,
                                      maxLength: null,
                                      maxLines: null,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              signed: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                            fontSize: 20,
                                          ),
                                          prefixIcon: currency == gccurrency
                                              ? Icon(Icons
                                                  .account_balance_wallet_sharp)
                                              : Icon(
                                                  CupertinoIcons.money_dollar),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          fillColor: Colors.white),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  DefaultButton(
                                      text: "Withdraw",
                                      press: () async {
                                        int amount =
                                            int.parse(amountcontroller.text);
                                        var response = DbBase().databaseRequest(
                                            userWithdraw,
                                            DbBase().postRequestType,
                                            body: {
                                              "userId":
                                                  Get.find<AuthController>()
                                                      .usermodel
                                                      .value!
                                                      .id,
                                              "amount": amount
                                            });
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AsyncProgressDialog(
                                              response,
                                              message: Text("Please wait.."),
                                              onError: (e) {},
                                            );
                                          },
                                        );
                                        var waitedResponse =
                                            jsonDecode(await response);
                                        print("waitedResponse $waitedResponse");
                                        if (waitedResponse["status"] == false) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                waitedResponse["message"],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } else {
                                          // Get.snackbar(
                                          //   'Withdrawal Request Inititated',
                                          //   waitedResponse["message"],
                                          //   backgroundColor: Colors.green,
                                          // ).show();

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                waitedResponse["message"],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                        Get.back();
                                        print(waitedResponse);
                                        // int amount =
                                        //     int.parse(amountcontroller.text);
                                        // if (amount > 0) {
                                        //   onButtonPressed!(
                                        //       amountcontroller.text);
                                        // } else {
                                        //   ScaffoldMessenger.of(context)
                                        //       .showSnackBar(
                                        //     SnackBar(
                                        //       content: Text(
                                        //         "Amount has to be greater than 0",
                                        //         style: TextStyle(
                                        //             color: Colors.white),
                                        //       ),
                                        //       backgroundColor: Colors.red,
                                        //     ),
                                        //   );
                                        // }
                                      })
                                ]))
                      ],
                    ),
                  ),
                );
              });
        });

    // showModalBottomSheet(
    //   context: context,
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(15),
    //     topRight: Radius.circular(15),
    //   )),
    //   builder: (context) {
    //     return Container(
    //       child: Padding(
    //         padding: EdgeInsets.only(
    //             bottom: MediaQuery.of(context).viewInsets.bottom),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             InkWell(
    //               onTap: () {
    //                 Get.back();
    //               },
    //               child: Padding(
    //                 padding: MediaQuery.of(context).viewInsets,
    //                 child: Icon(Icons.clear, size: 30, color: Colors.white),
    //               ),
    //             ),
    //             Spacer(),
    //             Container(
    //               padding: EdgeInsets.symmetric(horizontal: 20),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text(
    //                     type == "send"
    //                         ? "How much ${currency == gccurrency ? "GistPoints" : "Money"} you want to send to ${userModel!.firstName!}"
    //                         : "Deposit  $type",
    //                     style: TextStyle(fontSize: 21),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Container(
    //                     decoration: new BoxDecoration(
    //                         shape: BoxShape.rectangle,
    //                         color: Colors.white,
    //                         borderRadius: BorderRadius.circular(10)),
    //                     padding: EdgeInsets.symmetric(horizontal: 10),
    //                     child: TextFormField(
    //                       controller: amountcontroller,
    //                       maxLength: null,
    //                       maxLines: null,
    //                       keyboardType: TextInputType.number,
    //                       decoration: InputDecoration(
    //                           hintStyle: TextStyle(
    //                             fontSize: 20,
    //                           ),
    //                           prefixIcon: currency == gccurrency
    //                               ? Icon(Icons.account_balance_wallet_sharp)
    //                               : Icon(CupertinoIcons.money_dollar),
    //                           border: InputBorder.none,
    //                           focusedBorder: InputBorder.none,
    //                           enabledBorder: InputBorder.none,
    //                           errorBorder: InputBorder.none,
    //                           disabledBorder: InputBorder.none,
    //                           fillColor: Colors.white),
    //                       style: TextStyle(
    //                         fontSize: 20,
    //                         color: Colors.black,
    //                         fontWeight: FontWeight.w400,
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   DefaultButton(
    //                       text: type == "send" ? "Send" : "Deposit",
    //                       press: () {
    //                         // int amount = int.parse(amountcontroller.text);
    //                         // if (amount > 0) {
    //                         //   onButtonPressed(type, amountcontroller.text);
    //                         // } else {
    //                         //   topTrayPopup(
    //                         //       "Amount has to be greater than 0");
    //                         // }
    //                       })
    //                 ],
    //               ),
    //             ),
    //             Spacer(),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
