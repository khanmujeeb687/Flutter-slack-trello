import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/custom_error.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/utils/custom_http_client.dart';
import 'package:wively/src/utils/my_urls.dart';

class UserRepository {
  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> getUsers() async {
    try {
      var response = await http.get('${MyUrls.serverUrl}/users');
      final List<dynamic> usersResponse = jsonDecode(response.body)['users'];
      final List<User> users =
          usersResponse.map((user) => User.fromJson(user)).toList();
      return users;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }


  Future<dynamic> editUser(Map<String, dynamic> data) async {
    try {
      var body=jsonEncode(data);
      var response = await http.put('${MyUrls.serverUrl}/user',body: body);
      final dynamic usersResponse = jsonDecode(response.body)['data'];
      if(usersResponse['ok']==1){
        return true;
      }
      return false;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<void> saveUserFcmToken(String fcmToken) async {
    try {
      var body = jsonEncode({'fcmToken': fcmToken});
      await http.post('${MyUrls.serverUrl}/fcm-token', body: body);
    } catch (err) {
      print("error $err");
    }
  }


  fetchUsersByIds(List<String> data) async{
    try {
      var response = await http.put('${MyUrls.serverUrl}/fetch-users',body: jsonEncode({'ids':data}));
      final List<dynamic> usersResponse = jsonDecode(response.body)['users'];
      final List<User> users =
      usersResponse.map((user) => User.fromJson(user)).toList();
      return users;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future <dynamic> joinLeaveChat(String userId, bool value) async{
    try {
      var response = await http.post('${MyUrls.ROOM}/join',body: jsonEncode({'roomId':userId,'value':value}));
      final dynamic usersResponse = jsonDecode(response.body)['data'];
      if(usersResponse!=null){
        return User.fromJson(usersResponse);
      }
      return null;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': err.toString()});
    }
  }
}
