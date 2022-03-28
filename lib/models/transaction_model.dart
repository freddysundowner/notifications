// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

import 'package:fluttergistshop/models/user_model.dart';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  TransactionModel({
    required this.date,
    required this.id,
    this.from,
    required this.to,
    required this.reason,
    required this.amount,
    required this.type,
    required this.deducting,
    required this.shopId,
  });

  int date;
  String id;
  UserModel? from;
  UserModel to;
  String reason;
  int amount;
  String type;
  bool deducting;
  String shopId;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
          date: json["date"],
          id: json["_id"],
          from: UserModel.fromJson(json["from"] ?? {}),
          to: UserModel.fromJson(json["to"]),
          reason: json["reason"],
          amount: json["amount"],
          type: json["type"],
          deducting: json["deducting"],
          shopId: json["shopId"]);

  Map<String, dynamic> toJson() => {
        "date": date,
        "_id": id,
        "from": from,
        "to": to,
        "reason": reason,
        "amount": amount,
        "type": type,
        "deducting": deducting,
        "shopId": shopId,
      };
}
