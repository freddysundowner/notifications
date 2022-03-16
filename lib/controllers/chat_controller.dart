import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttergistshop/models/all_chats_model.dart';
import 'package:fluttergistshop/models/chat_room_model.dart';
import 'package:fluttergistshop/models/user.dart';
import 'package:fluttergistshop/utils/functions.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import 'auth_controller.dart';

class ChatController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var allUserChats = [].obs;
  var gettingChats = false.obs;
  var currentChatLoading = false.obs;
  var currentChat = [].obs;
  var currentChatUsers = [].obs;

  @override
  void onInit() {
    getUserChats();
    super.onInit();
  }

  getUserChats() {
    gettingChats.value = true;

    String userId = Get.find<AuthController>().usermodel.value!.id!;
    db
        .collection("chats")
        .where("userIds", arrayContains: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      gettingChats.value = false;

      printOut("Chats loaded ${querySnapshot.docs.lengthGwtt}");

      for (var i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot snapshot = querySnapshot.docs.elementAt(i);
        var lastSender = snapshot.get("lastSender");

        List<String> group = snapshot.get("userIds");
        var otherUser = "";
        for (String user in group) {
          if (user != userId) {
            printOut("Other user Id " + user);
            otherUser = user;
          }
        }

        AllChatsModel allChatsModel = AllChatsModel(
            snapshot.id,
            otherUser,
            snapshot.get("lastMessage"),
            snapshot.get("lastMessageTime").toString(),
            lastSender.get("firstName").equals(userId)
                ? "You"
                : lastSender.get("firstName"),
            false);

        allUserChats.add(allChatsModel);
      }
    }).onError((error, stackTrace) {
      gettingChats.value = false;
      printOut("Error getting all chats $error $stackTrace");
    });
  }

  getChatById(String id) {
    db.collection("chats/$id/messages").get().then((QuerySnapshot snapshot) {
      for (var i = 0; i < snapshot.docs.length; i++) {
        DocumentSnapshot documentSnapshot = snapshot.docs.elementAt(i);

        ChatRoomModel chatRoomModel = ChatRoomModel(
            documentSnapshot.get("date"),
            documentSnapshot.id,
            documentSnapshot.get("message"),
            documentSnapshot.get("seen"),
            documentSnapshot.get("sender"));
        currentChat.add(chatRoomModel);
      }
    });

    db.collection("chats/$id/users").get().then((QuerySnapshot snapshot) {
      for (var i = 0; i < snapshot.docs.length; i++) {
        DocumentSnapshot documentSnapshot = snapshot.docs.elementAt(i);

        UserModel userModel = UserModel.fromPlayer(documentSnapshot.id,
            documentSnapshot.get("firstName"), documentSnapshot.get("lastName"),
            documentSnapshot.get("bio"), documentSnapshot.get("userName"),
            documentSnapshot.get("phonenumber"), documentSnapshot.get("profilePhoto"));

        currentChatUsers.add(userModel);

      }
    });
  }
}
