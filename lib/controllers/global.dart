import 'package:flutter/material.dart';
import 'package:fluttergistshop/services/shop_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  var currentsearchtab = 0.obs;
  var tabPosition = 0.obs;
  TextEditingController searchShopController = TextEditingController();
  var isSearching = false.obs;
  var canback = false.obs;

  var searchresults = [].obs;
  var searchoption = "".obs;

  final scrollcontroller = ScrollController();
  @override
  void onInit() {
    super.onInit();
    scrollcontroller.addListener(() {
      if (scrollcontroller.position.atEdge) {
        bool isTop = scrollcontroller.position.pixels == 0;
        if (isTop) {
          printOut('At the top');
        } else {
          search(searchoption.value,
              last: searchresults[searchresults.length - 1]["_id"]);
        }
      }
    });
  }

  Future<void> search(String searchOption, {last}) async {
    if (searchShopController.text.trim().isNotEmpty) {
      try {
        isSearching.value = true;
        var results = await ShopApi().searchItems(
            searchShopController.text.trim(), searchOption,
            last: last);
        //searchresults.assignAll(results);
        //searchresults.addAll(results);
        //

        for (var i = 0; i < results.length; i++) {
          if (searchresults.indexWhere(
                  (element) => element['_id'] == results[i]['_id']) ==
              -1) {
            searchresults.add(results[i]);
          }
        }

        isSearching.value = false;
      } catch (e) {
        printOut(e.toString());
        isSearching.value = false;
      }
    }
  }
}
