import 'dart:convert';

import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String username;
  String chatId;
  String profileUrl;
  bool online;
  int lastSeen;

  User({
    @required this.id,
    @required this.name,
    @required this.username,
    this.chatId,
    this.profileUrl,
    this.online,
    this.lastSeen
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    chatId = json['chatId'];
    profileUrl=json['profileUrl'];
    online=json['online']=='true';
    lastSeen=json['lastSeen'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'profileUrl': profileUrl,
      'lastSeen': lastSeen
    };
  }

  User.fromLocalDatabaseMap(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    profileUrl=json['profile_url'];
    lastSeen=json['last_seen'];
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['username'] = username;
    map['profile_url']= profileUrl;
    map['last_seen']= lastSeen;
    return map;
  }

  @override
  String toString() {
    return '{"_id":"$id","name":"$name","username":"$username","profileUrl":"$profileUrl","lastSeen":$lastSeen}';
  }
}
