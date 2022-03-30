import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/controllers/wallet_controller.dart';
import 'package:fluttergistshop/models/transaction_model.dart';
import 'package:fluttergistshop/utils/constants.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

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
                  height: 0.15.sh,
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
                        })
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
              const Divider(),
              SizedBox(
                height: 0.01.sh,
              ),
              Obx(() {
                return SizedBox(
                    height: 0.55.sh,
                    child: _walletController.transactionsLoading.isFalse
                        ? _walletController.userTransaction.isNotEmpty
                            ? ListView.builder(

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
                                            fontSize: 16.sp),
                                      ),
                                      SizedBox(
                                        height: 0.02.sh,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            transaction.reason.trim().length >
                                                    20
                                                ? transaction.reason
                                                        .trim()
                                                        .capitalizeFirst!
                                                        .substring(0, 20) +
                                                    "..."
                                                : transaction.reason
                                                    .trim()
                                                    .capitalizeFirst!,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp), maxLines: 2,
                                          ),
                                          Text(
                                            "$gccurrency ${transaction.amount}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16.sp),
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
}
