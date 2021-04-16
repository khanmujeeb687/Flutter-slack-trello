import 'package:flutter/material.dart';
import 'package:wively/src/data/local_database/db_provider.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/task.dart';
import 'package:wively/src/data/repositories/task_board.repository.dart';
import 'package:wively/src/screens/task_board/task_board_view.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/widgets/lottie_loader.dart';


class AllTaskBoardsScreen extends StatefulWidget {
  @override
  _AllTaskBoardsScreenState createState() => _AllTaskBoardsScreenState();
}

class _AllTaskBoardsScreenState extends State<AllTaskBoardsScreen> {

  List<Room> rooms=[];
  List<Task> tasks=[];

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(tasks.length==0){
      return Center(
        child: lottieLoader(),
      );
    }
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(rooms.length, (index) => LimitedBox(
          maxHeight: ScreenUtil.height(context),
          maxWidth: ScreenUtil.width(context)*.9,
          child: TaskBoardView(rooms[index].id,tasks.where((element) => element.room==rooms[index].id).toList(),rooms[index]))),
    );
  }

  void init() async{
    fetchAllTasks();
    rooms=await DBProvider.db.getAllRooms();
    setState(() {});
  }

  void fetchAllTasks() async{
    var data=await new TaskBoardRepository().getAllUserTasks();
    if(data is List<Task>){
      setState(() {
        tasks.clear();
        tasks.addAll(data);
      });
    }
  }
}
