import 'package:fluttergistshop/models/product.dart';
import 'package:fluttergistshop/services/user_api.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var products = [].obs;
  var loading = false.obs;
  var favoritekey = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFavoriteProducts();
  }

  getFavoriteProducts() async {
    try {
      loading.value = true;
      var response = await UserAPI.getMyFavorites();
      print("response getFavoriteProducts ${response["_id"]}");
      favoritekey.value = response["_id"];
      products.value = response["productId"].map((e) {
        //  e["ownerId"] = null;
        return Product.fromJson(e);
      }).toList();
      loading.value = false;
      print(" getFavoriteProducts ${products.value.length}");
    } catch (e, s) {
      print("getFavoriteProducts Error ${e.toString()} $s");
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
