import 'dart:convert';

import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:flutter/material.dart';

class Chat {

  String id;
  List<Message> messages;
  Room room;
  User user;
  int unreadMessages;
  String lastMessage;
  int lastMessageSendAt;

  Chat({
    @required this.id,
    @required this.room,
    @required this.user,
    this.messages = const [],
    this.unreadMessages,
    this.lastMessage,
    this.lastMessageSendAt,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    room = Room.fromJson(json['room']);
    if(json.containsKey('user'))
      user = User.fromJson(json['user']);
    messages = [];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['_id'] = id;
    return json;
  }

  Chat.fromLocalDatabaseMap(Map<String, dynamic> map) {
    id = map['_id'];
    room = Room.fromLocalDatabaseMap({
      '_id': map['room_id'],
      'room_name': map['room_name'],
      'task_board_id':map['task_board_id']
    });
    user = User.fromLocalDatabaseMap({
      '_id': map['user_id'],
      'name': map['name'],
      'username': map['username'],
    });
    messages = [];
    unreadMessages = map['unread_messages'];
    lastMessage = map['last_message'];
    lastMessageSendAt = map['last_message_send_at'];
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    if(user!=null){
      map['user_id'] = user.id;
    }
    return map;
  }

  Future<Chat> formatChat() async {
    return this;
  }

}