import 'package:wively/src/data/models/task.dart';
import 'package:wively/src/data/repositories/task_board.repository.dart';
import 'package:wively/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class TaskBoardController extends StateControl {
  final BuildContext context;
  final TaskBoardRepository _taskBoardRepository=new TaskBoardRepository();

  bool loading=true;

  List<Task> tasks=[];

  TaskBoardController({
    @required this.context,
  }) {
    this.init();
  }

  void init() {

  }



  void fetchBoard(boardId) async{
    var data=await _taskBoardRepository.getAllTasks(boardId);
    if(data is List<Task>){
      tasks=data;
    }
    loading=false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
