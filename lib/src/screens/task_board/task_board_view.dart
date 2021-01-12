import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/task.dart';
import 'package:wively/src/screens/task_board/task_board_controller.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/custom_app_bar.dart';
import 'package:wively/src/widgets/lottie_loader.dart';




class TaskBoardScreen extends StatefulWidget {
  static final routeName='/TaskBoard';
  String roomId;
  TaskBoardScreen(this.roomId);
  @override
  _TaskBoardViewState createState() => _TaskBoardViewState();
}

class _TaskBoardViewState extends State<TaskBoardScreen> {

  TaskBoardController _taskBoardController;


  @override
  void initState() {
    _taskBoardController=new TaskBoardController(context: context);
    _taskBoardController.fetchBoard(widget.roomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _taskBoardController.streamController.stream,
        builder: (context, snapshot) {
          return Material(
            color: Colors.transparent,
            child: Hero(
              tag: widget.roomId,
              child: Scaffold(
                appBar: CustomAppBar(
                  title: Text('TaskBoard', style: TextStyle(color: EColors.white)),
                ),
                body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: .5,sigmaY: .5),
                        child: Card(
                          color: EColors.white.withOpacity(0.1),
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ) ,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add,color: EColors.themeGrey,),
                                      onPressed: _taskBoardController.addTask,
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8,20,8,8),
                                  child:(){
                                    if(_taskBoardController.loading){
                                      return lottieLoader();
                                    }
                                    if(_taskBoardController.tasks.length==0){
                                      return Center(
                                        child: Text("There are no Tasks on this board!",style: TextStyle(
                                          color: EColors.themeGrey
                                        ),)
                                        );
                                    }
                                    return ListView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _taskBoardController.tasks.length,
                                      itemBuilder: (context,index){
                                        return _card(_taskBoardController.tasks[index]);
                                      },
                                    );
                                  }(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ),
              ),
            ),
          );
        });
  }



  _card(Task task){
    return Card(
      color: EColors.white.withOpacity(0.5),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          onTap: ()=>_taskBoardController.changeStatus(task),
          leading: CircleAvatar(
            child: Text(task.title[0].toUpperCase()),
          ),
          title: Text(task.title,style: TextStyle(
            color: EColors.themeBlack
          ),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.desc.toString().replaceAll("null", '')),
              Text('Created by ~ '+task.createdBy.name),
            ],
          ),
          trailing: Column(
            children: [
              Text(task.status),
              if(task.assignedTo!=null)
                CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Text(task.createdBy.name[0].toUpperCase()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
