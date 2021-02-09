import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';

enum MediaType { Image, Video, Document }

class UploadService {
  File _file;
  MediaType _fileType;

  String _filename;
  String _savedDir;
  String _tag;
  String taskId;



  UploadService(File file, String tag, MediaType mediaType) {
    this._file = file;
    this._filename = basename(file.path);
    this._savedDir = dirname(file.path);
    this._fileType = mediaType;
    this._tag = tag;
  }




  FlutterUploader _uploader = FlutterUploader();
  StreamSubscription _progressSubscription;
  StreamSubscription _resultSubscription;




  String _getFileUrl(filename) {
    return "https://foodsfiesta.com/darwdawguploads/uploads/" + filename;
  }




  String _uploadUrl() {
    return "https://foodsfiesta.com/darwdawguploads/uploadfile.php";
  }




  Future<void> _getStarted(
      Function(String error) taskFailed,
      Function(String fileUrl) taskSuccess,
      Function(UploadTaskProgress progress) onProgress) async {
    _progressSubscription =
        _uploader.progress.listen((UploadTaskProgress progress) {
      onProgress(progress);
    });
    _resultSubscription = _uploader.result.listen((result) {
      if (result.status.value == 3) {
        taskSuccess(_getFileUrl(_filename));
      } else if (result.status.value == 5 || result.status.value == 4) {
        taskFailed('Upload failed');
      }
    }, onError: (ex, stacktrace) {
      final exp = ex as UploadException;
      taskFailed(exp.toString());
    });
  }




  Future<String> uploadFile(
      Function(String error) taskFailed,
      Function(String fileUrl) taskSuccess,
      Function(UploadTaskProgress progress) onProgress) async {
    await _getStarted(taskFailed,taskSuccess,onProgress);
    var url = _uploadUrl();
    var fileItem = FileItem(
      filename: _filename,
      savedDir: _savedDir,
      fieldname: 'video',
    );
    var taskId = await _uploader.enqueue(
      url: url,
      data: {"name": "john"},
      files: [fileItem],
      method: UploadMethod.POST,
      tag: _tag,
      showNotification: true,
    );
    this.taskId=taskId;
    return taskId;
  }



  Future cancelUpload(String id) async {
    await _uploader.cancel(taskId: id);
  }


  removeSubscriptions() {
    _progressSubscription?.cancel();
    _resultSubscription?.cancel();
  }
}
