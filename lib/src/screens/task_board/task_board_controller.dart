import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/task.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/data/repositories/room_repository.dart';
import 'package:wively/src/data/repositories/task_board.repository.dart';
import 'package:wively/src/screens/task_board/add_task_view.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:wively/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wively/src/widgets/task_status_dilaog.dart';

class TaskBoardController extends StateControl {
  final BuildContext context;
  final TaskBoardRepository _taskBoardRepository=new TaskBoardRepository();
  final RoomRepository _roomRepository=new RoomRepository();

  bool loading=true;

  List<Task> tasks=[];
  List<User> members=[];

  Room room;

  GlobalKey<FormState> key;
  String title;
  String desc;
  User selectedUser;



  TaskBoardController({
    @required this.context,
  }) {
    this.init();
  }

  void init() {
    key=GlobalKey<FormState>();
  }



  Future<void> getRoom(roomId) async{

    var data = await _roomRepository.getRoomById(roomId);
    if(data is Room){
      this.room=data;
    }
  }

  void fetchBoard(String roomId) async{
    if(room==null)
      await getRoom(roomId);
    var data=await _taskBoardRepository.getAllTasks(room.taskBoardId);
    if(data is List<Task>){
      tasks=data;
    }
    loading=false;
    notifyListeners();
  }

  getAllMembers(Room room)async{
    this.room=room;
    var data=await _roomRepository.getAllMembers(room.id);
    if(data is List<User>){
      members=data;
    }
    loading=false;
    notifyListeners();
  }

  addTask()async{
   await Navigator.pushNamed(context, AddTask.routeName,arguments: room);
   this.fetchBoard(room.id);
  }


  selectUser(User user)async{
   selectedUser=user;
   notifyListeners();
  }


  addNewTask()async{
    if(key.currentState.validate()){
      User user =await CustomSharedPreferences.getMyUser();
      var data =await _taskBoardRepository.createNewTask({
        'desc':desc,
        'title':title,
        'taskBoardId':room.taskBoardId,
        'assignedTo':selectedUser,
        'createdBy':user.id,
        'roomId':room.id,
      });
      if(data is Task){
        Navigator.pop(context);
      }else{
        Fluttertoast.showToast(msg: 'Some error occurred');
      }
    }
  }


  updateTask(Task task,status) async{
    _taskBoardRepository.editTask(task.id,status);
    Navigator.pop(context);
    tasks.removeAt(tasks.indexOf(task));
    task.status=status;
    tasks.insert(0, task);
    notifyListeners();
  }

  changeStatus(Task task){
    showDialog(
      context: context,
      builder: (context){
        return TaskStatusDialog((){
          updateTask(task, 'done');
        }, (){
          updateTask(task, 'un_done');
        });
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
