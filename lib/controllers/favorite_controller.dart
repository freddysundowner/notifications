import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  RxList<dynamic> products = RxList([]);
  var loading = false.obs;
  var favoritekey = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFavoriteProducts();
  }

  Future<List> getFavoriteProducts() async {
    try {
      loading.value = true;
      var response = await UserAPI.getMyFavorites();
      print("response getFavoriteProducts ${response["_id"]}");
      favoritekey.value = response["_id"];
      List allproducts = response["productId"].map((e) {
        return Product.fromJson(e);
      }).toList();
      allproducts.removeWhere(
          (element) => element.available == false || element.deleted == true);
      products.value = allproducts;
      loading.value = false;
      return allproducts;
    } catch (e, s) {
      return [];
    }
  }

  saveFavorite(String productId) async {
    try {
      var response = await UserAPI.saveFovite(productId);
      printOut(" resp $response");
      products.value = response["productId"].map((e) {
        return Product.fromJson(e);
      }).toList();
      favoritekey.value = response["_id"];
      print(" getFavoriteProducts ${products.value.length}");
    } catch (e, s) {
      print("getFavoriteProducts Error ${e.toString()} $s");
    }
  }

  deleteFavorite(String productId) async {
    try {
      var response = await UserAPI.deleteFromFavorite(productId);
      products.value = response["productId"].map((e) {
        return Product.fromJson(e);
      }).toList();
      print(" getFavoriteProducts ${products.value.length}");
    } catch (e, s) {
      print("getFavoriteProducts Error ${e.toString()} $s");
    }
  }
}
