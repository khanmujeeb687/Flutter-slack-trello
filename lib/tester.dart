import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/services/upload_service.dart';
import 'package:wively/src/utils/file_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/buttons.dart';

class Tester extends StatefulWidget {
  @override
  _TesterState createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  UploadService uploadService;
  String progress="0";
  String fileUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Column(
          children: [
            ESquareButton("Upload An Image",
            onPressed: onTap
            ),
            SizedBox(height: 50,),
            Text('progress-->>>>'+progress,style: TextStyle(color: EColors.white),),
            if(fileUrl!=null)
              Image.network(fileUrl)
          ],
        ),
      ),
    );
  }

  void onTap() async{
    String filePath=await FileUtil.selectImageFromDevice();
    if(filePath!=null){
      uploadFile(filePath);
    }
  }

  void uploadFile(String filePath) async{
    uploadService=new UploadService(File(filePath), filePath, MediaType.Document);
    uploadService.uploadFile(onFail, onSuccess, onProgress);
  }


  @override
  void dispose() {
    uploadService?.removeSubscriptions();
    super.dispose();
  }

  onProgress(UploadTaskProgress progress) {
    setState(() {
      this.progress=progress.progress.toString();
    });
  }

  onSuccess(String fileUrl) {
    setState(() {
      this.fileUrl=fileUrl;
    });
    uploadService.removeSubscriptions();
  }

  onFail(String error) {
    Fluttertoast.showToast(msg: error);
    uploadService.removeSubscriptions();
  }
}
