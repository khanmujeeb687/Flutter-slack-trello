import 'dart:convert';

import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:flutter/material.dart';

class Room {


  String id;
  String roomName;
  User createdBy;
  List<User> admins;
  List<User> members;
  int createdAt;
  // String taslBoardId;
  // Room parent;

  Room({
    @required this.id,
    @required this.roomName,
    @required this.createdBy,
    this.createdAt,
    this.members,
    this.admins,
  });

  Room.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    roomName = json['roomName'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    members = json['members'].map((member)=>User.fromJson(member));
    admins = json['admins'].map((admin)=>User.fromJson(admin));
  }



  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['room_name'] = roomName;
    return map;
  }

  Room.fromLocalDatabaseMap(Map<String, dynamic> json) {
    id = json['_id'];
    roomName = json['room_name'];
  }




}
