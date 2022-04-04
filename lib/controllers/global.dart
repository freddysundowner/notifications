import 'package:flutter/material.dart';
import 'package:fluttergistshop/services/shop_api.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  var currentsearchtab = 0.obs;
  var tabPosition = 0.obs;
  TextEditingController searchShopController = TextEditingController();
  var isSearching = false.obs;

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
          print('At the top');
        } else {
          print('At the bottom');
          print('entered ${searchShopController.text}');
          print(
              'entered ${searchresults.value[searchresults.value.length - 1]["_id"]}');
          // print('At the bottom vv ${searchresults.value.last["_id"]}');
          // print('At the bottom ${searchShopController.text}');
          search(searchoption.value,
              last: searchresults.value[searchresults.value.length - 1]["_id"]);
        }
      }
    });
  }

  Future<void> search(String searchOption, {last}) async {
    print("searchShopController.text ${searchShopController.text}");
    if (searchShopController.text.trim().isNotEmpty) {
      try {
        isSearching.value = true;
        var results = await ShopApi().searchItems(
            searchShopController.text.trim(), searchOption,
            last: last);

        searchresults.assignAll(results);

        isSearching.value = false;
      } catch (e) {
        printOut(e.toString());
        isSearching.value = false;
      }
    }
  }
}
