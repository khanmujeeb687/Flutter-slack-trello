import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/controller/message_controller.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/services/upload_service.dart';
import 'package:wively/src/utils/message_utils.dart';

import 'chats_provider.dart';

class UploadItem {
  final String id;
  final String tag;
  final MediaType type;
  final int progress;
  final UploadTaskStatus status;
  final Message message;
  final fileUri;

  UploadItem(
      {this.id,
      this.tag,
      this.type,
      this.progress = 0,
      this.status = UploadTaskStatus.undefined,
      this.fileUri,
      this.message});

  UploadItem copyWith({UploadTaskStatus status, int progress}) => UploadItem(
      id: this.id,
      tag: this.tag,
      type: this.type,
      message: this.message,
      fileUri: this.fileUri,
      status: status ?? this.status,
      progress: progress ?? this.progress);

  bool isCompleted() =>
      this.status == UploadTaskStatus.canceled ||
      this.status == UploadTaskStatus.complete ||
      this.status == UploadTaskStatus.failed;
}

class UploadsProvider extends ChangeNotifier {
  final BuildContext context;

  UploadsProvider(this.context);

  FlutterUploader uploader = FlutterUploader();
  StreamSubscription _progressSubscription;
  StreamSubscription _resultSubscription;
  Map<String, UploadItem> _tasks = {};

  Map<String, UploadItem> get tasks => _tasks;

  void init() {
    if (_progressSubscription != null && _progressSubscription != null) return;
    _progressSubscription = uploader.progress.listen((progress) {
      final task = _tasks[progress.tag];
      print("progress: ${progress.progress} , tag: ${progress.tag}");
      if (task == null) return;
      if (task.isCompleted()) return;
      _tasks[progress.tag] =
          task.copyWith(progress: progress.progress, status: progress.status);
      notifyListeners();
    });
    _resultSubscription = uploader.result.listen((result) {
      checkCompletion(result);
      print(
          "id: ${result.taskId}, status: ${result.status}, response: ${result.response}, statusCode: ${result.statusCode}, tag: ${result.tag}, headers: ${result.headers}");

      final task = _tasks[result.tag];
      if (task == null) return;
      _tasks[result.tag] = task.copyWith(status: result.status);
      notifyListeners();
    }, onError: (ex, stacktrace) {
      print("exception: $ex");
      print("stacktrace: $stacktrace" ?? "no stacktrace");
      final exp = ex as UploadException;
      final task = _tasks[exp.tag];
      if (task == null) return;
      _tasks[exp.tag] = task.copyWith(status: exp.status);
      notifyListeners();
    });
  }

  String _uploadUrl() {
    return "https://foodsfiesta.com/darwdawguploads/uploadfile.php";
  }

  uploadFile(File file, String tag, Message message) async {
    tasks.remove(tag);
    init();
    final String filename = basename(file.path);
    final String savedDir = dirname(file.path);
    var url = _uploadUrl();
    var fileItem = FileItem(
      filename: filename,
      savedDir: savedDir,
      fieldname: "video",
    );

    var taskId = await uploader.enqueue(
      url: url,
      data: {"name": "john"},
      files: [fileItem],
      method: UploadMethod.POST,
      tag: tag,
      showNotification: true,
    );

    _tasks.putIfAbsent(
        tag,
        () => UploadItem(
              fileUri: _getFileUrl(filename),
              id: taskId,
              tag: tag,
              message: message,
              type: MessageUtil.getMediaTypeFromMessageType(
                  MessageUtil.getTypeFromUrl(_getFileUrl(filename))),
              status: UploadTaskStatus.enqueued,
            ));
  }

  String _getFileUrl(filename) {
    return "https://foodsfiesta.com/darwdawguploads/uploads/" + filename;
  }

  Future cancelUpload(String id) async {
    await uploader.cancel(taskId: tasks[id]?.id);
  }

  destroy() {
    _progressSubscription?.cancel();
    _resultSubscription?.cancel();
  }

  void checkCompletion(UploadTaskResponse result) {
    if (result.status == UploadTaskStatus.complete) {
      MessageController().sendMessage(tasks[result.tag].message,
          MessageUtil.getMessageTypeFromMediaType(tasks[result.tag].type),
          filesUri: tasks[result.tag].fileUri);
      updateLocalStatus(EFileState.sent, tasks[result.tag].message);
    } else if (result.status == UploadTaskStatus.failed ||
        result.status == UploadTaskStatus.canceled) {
      updateLocalStatus(EFileState.unsent, tasks[result.tag].message);
    }
  }

  Future<void> updateLocalStatus(EFileState fileState, Message message) async {
    await Provider.of<ChatsProvider>(context, listen: false)
        .updateMessageState(message.localId, fileState);
    notifyListeners();
  }
}
