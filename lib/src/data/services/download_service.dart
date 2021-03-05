import 'dart:io';

import 'package:flutter/foundation.dart';

class DownloadService {

  var httpClient;

  DownloadService(){
    this.httpClient=new HttpClient();
  }

  Future<File> downloadFile(String url,String destination) async {
    try{
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      File file = new File(destination);
      await file.writeAsBytes(bytes);
      return file;
    }catch(e){
      return null;
    }

  }




  // String taskId;
  // String _filePath;
  //
  // static init() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await FlutterDownloader.initialize(debug: true);
  // }
  //
  // DownloadService(Function(DownloadTaskStatus status) callback) {
  //   FlutterDownloader.registerCallback(
  //       (String id, DownloadTaskStatus status, int progress) {
  //     if (status != DownloadTaskStatus.running) {
  //       callback(status);
  //     }
  //   });
  // }
  //
  // downloadFile(String url, String destination) async {
  //   this._filePath=destination;
  //   final taskId = await FlutterDownloader.enqueue(
  //     url: url,
  //     savedDir: destination,
  //     showNotification: false,
  //     openFileFromNotification: false,
  //   );
  //
  //   this.taskId = taskId;
  // }
  //
  // stop() async {
  //   FlutterDownloader.cancel(taskId: taskId);
  // }
  //
  // getFilePath(){
  //   return this._filePath;
  // }
}
