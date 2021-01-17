import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:objectid/objectid.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/task.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/repositories/room_repository.dart';
import 'package:wively/src/data/repositories/task_board.repository.dart';
import 'package:wively/src/screens/task_board/add_task_view.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wively/src/widgets/loader_dialog.dart';
import 'package:wively/src/widgets/task_status_dilaog.dart';

class TaskBoardController extends StateControl {
  final BuildContext context;
  final TaskBoardRepository _taskBoardRepository=new TaskBoardRepository();
  final RoomRepository _roomRepository=new RoomRepository();
  ChatsProvider _provider;

  ScrollController scrollController=new ScrollController();
  GlobalKey<AnimatedListState> listKey=new GlobalKey<AnimatedListState>();


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
  _provider  = Provider.of<ChatsProvider>(context, listen: false);
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

  Future<void> fetchBoard(String roomId) async{
    if(room==null)
      await getRoom(roomId);
    var data=await _taskBoardRepository.getAllTasks(room.taskBoardId);
    if(data is List<Task>){
      tasks.clear();
      tasks.addAll(data);
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

  Task prepareTask(Map<String,dynamic> map,localId){
    map['createdBy']=_provider.currentUser.toJson();
    map['status']='not_done';
    map['_id']=localId;
    return Task.fromJson(map);
  }

  addTaskLocally(Map<String,dynamic> map,String localId)async{
    tasks.add(prepareTask(map,localId));
    scrollToBottom();
    listKey.currentState.insertItem(tasks.length-1,duration: Duration(milliseconds: 500));
  }

  scrollToBottom()=> scrollController.animateTo(scrollController.position.maxScrollExtent+100,duration: Duration(milliseconds: 300),curve: Curves.easeIn);


  addNewTask(bool goBack)async{
    if(key.currentState.validate()){
      key.currentState.reset();
      if(goBack)
        LoaderDialogManager.showLoader(context);
      User user =await CustomSharedPreferences.getMyUser();
      Map<String ,dynamic> newTaskData={
        'desc':desc,
        'title':title,
        'taskBoardId':room.taskBoardId,
        'assignedTo':selectedUser,
        'createdBy':user.id,
        'roomId':room.id,
      };
      String localObjectId=getLocalIdForLocaltask();
      if(!goBack)
        addTaskLocally(newTaskData,localObjectId);
      var data =await _taskBoardRepository.createNewTask(newTaskData);
      if(data is Task){
        if(goBack)
          Navigator.pop(context);
        else
          addIdToNewTask(data,localObjectId);
      }else{
        Fluttertoast.showToast(msg: 'Some error occurred');
      }
      if(goBack)
        LoaderDialogManager.hideLoader();
    }
  }


  updateTask(Task task,status) async{
    if(isLocalObjectId(task.id)) return Navigator.pop(context);
    _taskBoardRepository.editTask(task.id,status);
    Navigator.pop(context);
    int index=tasks.indexOf(task);
    tasks[index].status=status;
    notifyListeners();
  }

  changeStatus(Task task){
    ScreenUtil.dismissKeyBoard();
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

  void addIdToNewTask(Task data,String id) {
    int index = tasks.indexOf(tasks.where((element) => element.id==id).first);
    tasks[index].id=data.id;
  }

  String getLocalIdForLocaltask(){
    return  ObjectId().hexString+'__wively';
  }

  bool isLocalObjectId(String id){
    return id.contains('__wively');
  }
}
