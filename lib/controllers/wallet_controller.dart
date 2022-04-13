import 'package:fluttergistshop/services/transaction_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../services/user_api.dart';

class WalletController extends GetxController {
  var userTransaction = [].obs;
  var transactionsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
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


}