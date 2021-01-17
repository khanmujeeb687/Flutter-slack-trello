import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/screens/task_board/task_board_controller.dart';
import 'package:wively/src/widgets/SimpleTextFormField.dart';
import 'package:wively/src/widgets/collapsible_scaffold.dart';
import 'package:wively/src/widgets/lottie_loader.dart';
import 'package:wively/src/widgets/select_member.dart';



class AddTask extends StatefulWidget {
  static final routeName='/add_task';
  Room room;
  AddTask(this.room);
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TaskBoardController _taskBoardController;

  @override
  void initState() {
    _taskBoardController=new TaskBoardController(context: context);
    _taskBoardController.getAllMembers(widget.room);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: _taskBoardController.streamController.stream,
      builder: (context, snapshot) {
        return Scaffold(
          body:CollapsibleScaffold("Add Task",
              Form(
                key: _taskBoardController.key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SimpleTextFormField(hint: 'Title',validator: (a){
                        if(a.isEmpty) return "Please enter the titile";
                        _taskBoardController.title=a;
                        return null;
                      },),
                      SimpleTextFormField(bigField: true,hint: 'Description',onChange: (a){
                       _taskBoardController.desc=a;
                      }),
                      _taskBoardController.loading?lottieLoader():SelectMember(_taskBoardController.members,_taskBoardController.selectUser)
                      ,CupertinoButton(
                        child: Text("create"),
                        onPressed:_taskBoardController.backWithTask,
                      )
                    ],
                  ),
                ),
              )
              ,
              null
          )
        );
      }
    );
  }
}
