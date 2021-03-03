import 'dart:convert';

import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String username;
  String chatId;
  String profileUrl;

  User({
    @required this.id,
    @required this.name,
    @required this.username,
    this.chatId,
    this.profileUrl
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    chatId = json['chatId'];
    profileUrl=json['profileUrl'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'profileUrl': profileUrl
    };
  }

  User.fromLocalDatabaseMap(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    profileUrl=json['profile_url'];
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['username'] = username;
    map['profile_url']= profileUrl;
    return map;
  }

  @override
  String toString() {
    return '{"_id":"$id","name":"$name","username":"$username","profileUrl":"$profileUrl"}';
  }
}
