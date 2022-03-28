import 'package:flutter/material.dart';
import 'package:fluttergistshop/services/shop_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  var currentsearchtab = 0.obs;

  TextEditingController searchShopController = TextEditingController();
  var isSearching = false.obs;

  var searchresults = [].obs;

  Future<void> search(String searchOption) async {
    if (searchShopController.text.trim().isNotEmpty) {
      try {
        isSearching.value = true;
        var results = await ShopApi()
            .searchItems(searchShopController.text.trim(), searchOption);
        searchresults.assignAll(results);

        isSearching.value = false;
      } catch (e) {
        printOut(e.toString());
        isSearching.value = false;
      }
    }
  }
}
