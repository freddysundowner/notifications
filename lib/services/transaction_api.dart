import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'client.dart';
import 'end_points.dart';

class TransactionAPI {
  getUserTransactions() async {
    var transactions = await DbBase().databaseRequest(
        userTransactions + FirebaseAuth.instance.currentUser!.uid,
        DbBase().getRequestType);

    return jsonDecode(transactions);
  }

  getMoreUserTransactions(int pageNumber) async {
    var transactions = await DbBase().databaseRequest(
        userTransactionsPaginated +
            FirebaseAuth.instance.currentUser!.uid + "/" +
            pageNumber.toString(),
        DbBase().getRequestType);

    return jsonDecode(transactions);
  }
}
