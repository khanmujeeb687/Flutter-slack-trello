import 'dart:io';

import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/values/constants.dart';

class FileUtil {
  static selectImageFromDevice() async {

    try{
      // PickedFile file = await ImagePicker.platform.pickImage(source: ImageSource.gallery, imageQuality: 15);
      List<Asset> files=await MultiImagePicker.pickImages(maxImages: 1,materialOptions:
      MaterialOptions(
        actionBarColor: 'black',
        statusBarColor: 'black',
      ));

      String paths='';

      for(int i =0;i<files.length;i++){
        String newFilePath=await writeToFile(await files[i].getByteData(quality: 10));
        paths+="|"+newFilePath;
      }

      return paths.length>0?paths.substring(1):null;
    }catch(e){
      return null;
    }

  }

  static Future<String> createPhotoDirectory() async{
    Directory appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;
    new Directory(appDocPath + Constants.PHOTO_DIRECTORY).createSync(recursive: true);
    return appDocPath + Constants.PHOTO_DIRECTORY;
  }

  static copyToImageDirectory(String filePath) async {

  }


  static fileOriginType(String path){
    if(path.split(':')[0].toLowerCase().contains('http')){
      return EOrigin.remote;
    }
    else return EOrigin.local;
  }


  static Future<String> writeToFile(ByteData data) async{
    String path=await createPhotoDirectory()+'/'+DateTime.now().millisecondsSinceEpoch.toString()+'.jpeg';
    final buffer = data.buffer;
    await new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return path;
  }

}
