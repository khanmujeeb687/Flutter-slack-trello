import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/custom_error.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/utils/custom_http_client.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:wively/src/utils/my_urls.dart';

class RoomRepository{
   CustomHttpClient http = CustomHttpClient();


   Future<dynamic> createRoom(roomName,roomId) async {
    try {
      User user=await CustomSharedPreferences.getMyUser();
      var body = jsonEncode({ "roomName":roomName, "createdBy":user.id, "createdAt":DateTime.now().microsecondsSinceEpoch,"parent":roomId});
      var response = await http.post(
        MyUrls.ROOM,
        body: body,
      );
      final dynamic roomJson = jsonDecode(response.body)['room'];

    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

   Future<dynamic> getRooms(parentId) async {
    try {
      User user=await CustomSharedPreferences.getMyUser();
      var url=parentId==null?(MyUrls.ROOM+'/'+user.id):(MyUrls.ROOM+'/'+user.id+'/'+parentId);
      var response = await http.get(url);
      final dynamic roomJson = jsonDecode(response.body)['rooms'];
      debugPrint(roomJson.toString());
      List<Room> rooms=[];
      roomJson?.forEach((room)=>rooms.add(Room.fromJson(room)));
      // final List<dynamic> rooms = roomJson.map((room) => Room.fromJson(room)).toList();
      return rooms;
    } catch (err) {
      debugPrint(err.toString());
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> getRoomById(String roomId)async{
    try {
      var response = await http.get(MyUrls.ROOM_ONE+'/'+roomId);
      final dynamic roomJson = jsonDecode(response.body)['room'];
      Room room =Room.fromJson(roomJson);
      return room;
    } catch (err) {
      Fluttertoast.showToast(msg:err.toString());
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> addNewMember(String roomId,String userId)async{
    try {
      var body = jsonEncode({ "roomId":roomId, "userId":userId});
      var response = await http.post(MyUrls.ADD_USER_TO_ROOM,body: body);
      var resDecode=jsonDecode(response.body);
      if(resDecode.containsKey('info')){
        Map<String,dynamic> message= jsonDecode(response.body)['info']['message'];
        return message;
      }
      return null;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> getAllMembers(String roomId)async{
    try {
      String url=MyUrls.GET_ALL_MEMBERS+'/'+roomId;
      var response = await http.get(url);
      final List<dynamic> roomJson = jsonDecode(response.body)['members'];
      final List<User> users =
      roomJson.map((user) => User.fromJson(user)).toList();
      return users;
    } catch (err) {
      Fluttertoast.showToast(msg:err);
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }
}