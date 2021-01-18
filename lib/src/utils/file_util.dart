import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FileUtil{

  static selectImageFromDevice()async{
   PickedFile file =await  ImagePicker.platform.pickImage(source: ImageSource.gallery,imageQuality: 15);
   if(file!=null) return file.path;
   return null;
  }

}