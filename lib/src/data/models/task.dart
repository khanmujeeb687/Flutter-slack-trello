import 'package:wively/src/data/models/user.dart';

class Task{

  String id;
  String desc;
  String title;
  String status;
  String taskBoardId;
  User assignedTo;
  User createdBy;
  String deadline;
  String room;

  Task({this.id,this.desc,this.title,this.status,this.taskBoardId,this.assignedTo,this.createdBy,this.deadline,this.room});


  Task.fromJson(Map<String, dynamic> map){
    id=map['_id'];
    desc=map['desc'];
    title=map['title'];
    status=map['status'];
    taskBoardId=map['taskBoardId'];
    assignedTo=User.fromJson(map['assignedTo']);
    createdBy=User.fromJson(map['createdBy']);
    deadline=map['deadline'];
    room=map['room'];
  }

}