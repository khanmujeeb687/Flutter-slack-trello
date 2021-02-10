import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/utils/permission_util.dart';
import 'package:wively/src/values/constants.dart';

class FileUtil {
  static selectImageFromDevice() async {
    PickedFile file = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 15);
    if (file != null) return file.path;
    return null;
  }

  static Future<String> createPhotoDirectory() async{
    Directory appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;
    new Directory(appDocPath + Constants.PHOTO_DIRECTORY).createSync(recursive: true);
    return appDocPath + Constants.PHOTO_DIRECTORY;
  }

  static copyToImageDirectory(String filePath) async {

  }





  static fileType(String path){
    if(path.split(':')[0].toLowerCase().contains('http')){
      return EOrigin.remote;
    }
    else return EOrigin.local;
  }

}
