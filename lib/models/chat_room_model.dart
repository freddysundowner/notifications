

class ChatRoomModel {

  String date;
  String id;
  String message;
  bool seen;
  String sender;

  ChatRoomModel(this.date, this.id, this.message, this.seen, this.sender);

  Map<String, dynamic> toMap() {
    return {
      'date': this.date,
      'id': this.id,
      'message': this.message,
      'seen': this.seen,
      'sender': this.sender,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      map['date'] as String,
      map['id'] as String,
      map['message'] as String,
      map['seen'] as bool,
      map['sender'] as String,
    );
  }
}