import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/providers/uploads_provider.dart';
import 'package:wively/src/utils/state_control.dart';

class FileMessageController extends StateControl {
  final BuildContext context;
  final Message message;

  UploadsProvider _uploadsProvider;

  UploadItem get task => _uploadsProvider?.tasks[message?.fileUrls];

  FileMessageController({@required this.context, @required this.message}) {
    init();
  }



  init() async {
    _uploadsProvider = Provider.of<UploadsProvider>(context);
    notifyListeners();
  }


  uploadFile() async {
   _uploadsProvider?.uploadFile(File(message?.fileUrls), message.fileUrls,message);
  }


  stopUpload() async{
    _uploadsProvider?.cancelUpload(message.fileUrls);
  }

}
