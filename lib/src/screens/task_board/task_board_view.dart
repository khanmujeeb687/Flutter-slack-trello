import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/task.dart';
import 'package:wively/src/screens/task_board/task_board_controller.dart';
import 'package:wively/src/widgets/custom_app_bar.dart';




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
                backgroundColor: Color(0xFFEEEEEE),
                appBar: CustomAppBar(
                  title: Text('TaskBoard', style: TextStyle(color: Colors.black)),
                ),
                body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    child: Card(
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
                                  icon: Icon(Icons.add),
                                  onPressed: _taskBoardController.addTask,
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8,20,8,8),
                              child: _taskBoardController.loading?Center(child: CupertinoActivityIndicator()):ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _taskBoardController.tasks.length,
                                itemBuilder: (context,index){
                                  return _card(_taskBoardController.tasks[index]);
                                },
                              ),
                            ),
                          ],
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
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          onTap: ()=>_taskBoardController.changeStatus(task),
          leading: CircleAvatar(
            child: Text(task.title[0]),
          ),
          title: Text(task.title),
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
                child: Text(task.createdBy.name),
              )
            ],
          ),
        ),
      ),
    );
  }
}
