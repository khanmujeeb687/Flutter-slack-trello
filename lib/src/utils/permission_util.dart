import 'package:permission_handler/permission_handler.dart';

class PermissionUtil{

  static Future<bool> checkAndRequestStoragePermission()async{
    PermissionStatus status = await Permission.storage.status;
    if(status!=PermissionStatus.granted){
      status=await Permission.storage.request();
    }
    return status==PermissionStatus.granted;
  }
}