import 'dart:io';

import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wively/src/data/models/file_models.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/constants.dart';

class FileUtil {
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
    String thumbName=DateTime.now().toString()+'-alfa';
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

}
