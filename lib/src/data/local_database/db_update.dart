import 'package:wively/src/data/local_database/db_provider.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/data/repositories/user_repository.dart';
import 'package:wively/src/values/Colors.dart';

class DBUpdate{

  UserRepository _userRepository=new UserRepository();

  _getAllUsers() async{
    List<Map<String ,dynamic>> userIds=await DBProvider.db.getAllUserIds();
    return userIds;
  }


 Future<void> _updateLocal(List<User> data)async{
    for(int i=0;i<data.length;i++){
        await DBProvider.db.updateUser(data[i]);
    }
    return;
  }

  Future<void> updateUserDatabase() async{
    List<Map<String ,dynamic>> userIds=await _getAllUsers();
    if(userIds!=null && userIds.length>0) {
      List<String> data=[];
      for(int i=0;i<userIds.length;i++){
        data.add(userIds[i]['_id']);
      }
      List<User> users = await _userRepository.fetchUsersByIds(data);
     await _updateLocal(users);
    }
  }

}