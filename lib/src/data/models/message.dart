
class Message {

  int localId;
  String id;
  String roomId;
  String message;
  String from;
  String to_room;
  int sendAt;
  bool unreadByMe;

  Message({
    this.localId,
    this.id,
    this.roomId,
    this.message,
    this.from,
    this.to_room,
    this.sendAt,
    this.unreadByMe,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    roomId = json['roomId'];
    message = json['message'];
    from = json['from']['_id'];
    to_room = json['room']['_id'];
    unreadByMe = json['unreadByMe'] ?? true;
    sendAt = json['sendAt'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['_id'] = id;
    json['roomId'] = roomId;
    json['message'] = message;
    json['from'] = from;
    json['room'] = to_room;
    json['sendAt'] = sendAt;
    return json;
  }

  Message.fromLocalDatabaseMap(Map<String, dynamic> json) {
    localId = json['id_message'];
    id = json['_id'];
    roomId = json['room_id'];
    message = json['message'];
    from = json['from_user'];
    to_room = json['to_room'];
    sendAt = json['send_at'];
    unreadByMe = json['unread_by_me'] == 1;
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['room_id'] = roomId;
    map['message'] = message;
    map['from_user'] = from;
    map['to_room'] = to_room;
    map['send_at'] = sendAt;
    map['unread_by_me'] = unreadByMe ?? false;
    return map;
  }

  Message copyWith({
    int localId,
    String id,
    bool unreadByMe,
  }) {
    return Message(
      localId: localId ?? this.localId,
      id: id ?? this.id,
      roomId: this.roomId,
      message: this.message,
      from: this.from,
      to_room: this.to_room,
      sendAt: this.sendAt,
      unreadByMe: unreadByMe ?? this.unreadByMe,
    );
  }

}