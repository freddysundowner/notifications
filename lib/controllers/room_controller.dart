import 'package:fluttergistshop/models/room_model.dart';
import 'package:fluttergistshop/services/room_api.dart';
import 'package:fluttergistshop/utils/Functions.dart';
import 'package:get/state_manager.dart';

class RoomController extends GetxController{
  var room = RoomModel().obs;
  var isLoading = false.obs;


  @override
  void onInit() {
    getRooms();
    super.onInit();
  }

  getRooms() async {

    printOut(room.value);
  }


  Future<void> fetchRoom(String roomId) async {

    try {
      isLoading = true.obs;

      var roomResponse = await RoomAPI()
          .getRoomById(roomId);

      if (roomResponse != null) {
        room.value = roomResponse;
      }

    }finally {
      isLoading = false.obs;
    }
  }

}