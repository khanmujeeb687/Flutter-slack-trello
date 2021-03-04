import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/repositories/user_repository.dart';
import 'package:wively/src/data/services/upload_service.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/image_with_edit.dart';

class UserInfoItem extends StatefulWidget {
  @override
  _UserInfoItemState createState() => _UserInfoItemState();
}

class _UserInfoItemState extends State<UserInfoItem> {
  UploadService uploadService;
  UserRepository _userRepository = new UserRepository();
  bool loading = false;
  ChatsProvider _provider;
  bool initialized=false;
  User user;

  @override
  void didChangeDependencies() {
    if(!initialized){
      _provider = Provider.of<ChatsProvider>(context, listen: false);
        user = _provider.currentUser;
      initialized=true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: EColors.themeMaroon),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: <Widget>[
          ImageWithEdit(callback,loading: loading,user: user,large: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user?.name,
                    style: TextStyle(
                      color: EColors.themeGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '@'+user?.username,
                    style: TextStyle(
                      color: EColors.themeGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void callback(String path) async {
    uploadService =
        new UploadService(File(path), 'uploading..', MediaType.Image);
    uploadService.uploadFile(onError, onSuccess, onProgress);
    setState(() {
      loading = true;
    });
  }

  stopLoading() {
    setState(() {
      loading = false;
    });
  }

  onError(String error) {
    stopLoading();
  }

  onProgress(UploadTaskProgress progress) {}

  onSuccess(String fileUrl) async {
    bool response = await _userRepository.editUser({'profileUrl': fileUrl});
    if(response){
      Map<String ,dynamic> loc=user.toJson();
      loc['profileUrl']=fileUrl;
      _provider.updateCurrentUser(User.fromJson(loc));
      setState(() {
        user = User.fromJson(loc);
      });
    }
    stopLoading();
  }

  @override
  void dispose() {
    uploadService?.removeSubscriptions();
    // TODO: implement dispose
    super.dispose();
  }
}
