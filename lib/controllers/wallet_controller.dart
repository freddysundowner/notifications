import 'package:flutter/material.dart';
import 'package:fluttergistshop/services/transaction_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../services/user_api.dart';

class WalletController extends GetxController {
  var userTransaction = [].obs;
  var transactionsLoading = false.obs;
  var moreTransactionsLoading = false.obs;
  var transactionPageNumber = 0.obs;
  final transactionScrollController = ScrollController();


  @override
  void onInit() {
    super.onInit();

    transactionScrollController.addListener(() {
      if (transactionScrollController.position.atEdge) {
        bool isTop = transactionScrollController.position.pixels == 0;
        printOut('current position controller ' + transactionScrollController.position.pixels.toString());
        if (isTop) {
          printOut('At the top');
        } else {
          printOut('At the bottom');
          transactionPageNumber.value = transactionPageNumber.value + 1;
          getMoreTransactions();
        }
      }
    });

    getUserTransactions();
  }

  getUserTransactions() async {

    try {
      transactionsLoading.value = true;

      var transactions = await TransactionAPI().getUserTransactions();

      if (transactions != null) {
        userTransaction.value = transactions;
      }  else{
        userTransaction.value = [];
      }

      await UserAPI.getUserById();

      transactionsLoading.value = false;
    } catch(e, s) {
      transactionsLoading.value = false;
      printOut("Error getting user transactions $e $s");
    }
  }

  getMoreTransactions() async {

    try {
      moreTransactionsLoading.value = true;

      var transactions = await TransactionAPI().getMoreUserTransactions(transactionPageNumber.value);

      if (transactions != null) {
        userTransaction.addAll(transactions);
      }
      moreTransactionsLoading.value = false;
    } catch(e, s) {
      transactionsLoading.value = false;
      printOut("Error getting more user transactions $e $s");
    }
  }


}