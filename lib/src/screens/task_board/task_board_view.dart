import 'package:flutter/material.dart';
import 'package:wively/src/screens/task_board/task_board_controller.dart';
import 'package:wively/src/widgets/custom_app_bar.dart';



class TaskBoardScreen extends StatefulWidget {
  static final routeName='/TaskBoard';
  String boardId;
  TaskBoardScreen(this.boardId);
  @override
  _TaskBoardViewState createState() => _TaskBoardViewState();
}

class _TaskBoardViewState extends State<TaskBoardScreen> {

  TaskBoardController _taskBoardController;


  @override
  void initState() {
    _taskBoardController=new TaskBoardController(context: context);
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
              tag: widget.boardId,
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
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context,index){
                            return _card();
                          },
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



  _card(){
    return Card(
      elevation: 2,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
