import 'package:fluttergistshop/models/user.dart';

class AllChatsModel {
  String id;
  String? chatTitle;
  String imageUrl;
  String lastMessage;
  String lastMessageTime;
  String lastSender;
  List<dynamic> userIds;
  List<dynamic> users;

  AllChatsModel(this.id, this.chatTitle, this.imageUrl, this.lastMessage,
      this.lastMessageTime, this.lastSender, this.userIds, this.users);

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'chatTitle': this.chatTitle,
      'imageUrl': this.imageUrl,
      'lastMessage': this.lastMessage,
      'lastMessageTime': this.lastMessageTime,
      'lastSender': this.lastSender,
      'userIds': this.userIds,
      'users': this.users,
    };
  }

  factory AllChatsModel.fromMap(Map<String, dynamic> map) {
    return AllChatsModel(
      map['id'] as String,
      map['chatTitle'] as String,
      map['imageUrl'] as String,
      map['lastMessage'] as String,
      map['lastMessageTime'] as String,
      map['lastSender'] as String,
      map['userIds'] as List<dynamic>,
      map['users'] as List<UserModel>,
    );
  }
}