import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/data/repositories/user_repository.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/constants.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as Http;

class FileUtil {


  static Map<String, Uint8List> thumbStore={};

  static selectImageFromDevice() async {
    try {
      // PickedFile file = await ImagePicker.platform.pickImage(source: ImageSource.gallery, imageQuality: 15);
      List<Asset> files = await MultiImagePicker.pickImages(
          maxImages: 1,
          materialOptions: MaterialOptions(
            actionBarColor: 'black',
            statusBarColor: 'black',
          ));

      if(files==null && files.length==0){
        return null;
      }

      String newFilePath = await saveFileAndThumb(files[0]);

      return newFilePath;
    } catch (e) {
      return null;
    }
  }

  static Future<String> createPhotoDirectory() async {
    Directory appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;
    new Directory(appDocPath + Constants.PHOTO_DIRECTORY)
        .createSync(recursive: true);
    return appDocPath + Constants.PHOTO_DIRECTORY;
  }

  static copyToImageDirectory(String filePath) async {}

  static fileOriginType(String path) {
    if (path.split(':')[0].toLowerCase().contains('http')) {
      return EOrigin.remote;
    } else
      return EOrigin.local;
  }


  static saveFileAndThumb(Asset asset)async{
    String filename=DateTime.now().toString();
    String thumbName=filename+'-alfa';
    String filePath = await createPhotoDirectory() +
        '/' +
        filename+
        '.jpeg';
    String thumbPath = await createPhotoDirectory() +
        '/' +
        thumbName+
        '.jpeg';

    await writeToFile(await asset.getByteData(quality: 20),filePath);
    await writeToFile(await asset.getThumbByteData(100,100,quality: 3),thumbPath);

    return filePath;
  }

  static Future<String> writeToFile(ByteData data,String path) async {

    final buffer = data.buffer;
    await new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return path;
  }


 static String getThumbPath(String path){

    String exten=extension(path);

    String newPath=path;

    newPath= newPath.replaceFirst(exten, '-alfa'+exten);

    return newPath;

  }


  static createImageName()async{
    return await createPhotoDirectory() +
        '/' +
        DateTime.now().toString()+
        '.jpeg';
  }


  static createPathFromUrl(String url)async{
    var data=url.split('/');
    return await createPhotoDirectory() +
        '/' + data[data.length-1];
  }


  static getRemoteExtension(String path){
    var data=path.split('.');
    return '.'+data[data.length-1];
  }


  static openFileSelector([var specific]) async{
    File file=await FilePicker.getFile(type: FileType.custom,allowedExtensions: specific!=null?specific:['pdf','docx','mp4']);
    return file?.path;
  }

  static getFileName(String url){
    var arr=url.split('/');
    return arr[arr.length-1];
  }


  static String createThumbnailPath(String videoFile){
    return createPathFromUrl("NUN/"+getFileName(videoFile)+".jpeg");
  }


  static getBaseUrlWithOutExtension(String url){
    String data=getRemoteExtension(url);
    /// -1 because dont want to remove .
    url.substring(0,url.length-data.length-2);
  }


  static String getThumbPathFromUrl(String url){
    //TODO logic should be fixed
    return url.replaceAll('.jpeg', '-alfa.jpeg');
  }



  static Future<String> createThumbnail(String videoFile) async{
    String thumPath=createThumbnailPath(videoFile);

    //TODO this can fail also
    String output = await VideoThumbnail.thumbnailFile(
      thumbnailPath:thumPath ,
      video: videoFile,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 5,
    );
   return thumPath;
  }


  static Future<String> getRemoteFileSize()async{
    Http.Response r = await Http.head(url);
   return  r.headers["content-length"];
  }

 Future<Uint8List> getVideoThumbBytes( String videoFile) async{
    if(FileUtil.thumbStore[videoFile]!=null) return FileUtil.thumbStore[videoFile];
    Uint8List uint8list= await VideoThumbnail.thumbnailData(
      video: videoFile,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 100, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 5,
    );

    FileUtil.thumbStore.putIfAbsent(videoFile, () => uint8list);

    return uint8list;
  }

}
