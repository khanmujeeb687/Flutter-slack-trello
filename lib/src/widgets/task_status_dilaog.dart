import 'package:flutter/material.dart';


class TaskStatusDialog extends StatelessWidget {
  VoidCallback onDone;
  VoidCallback onUnDone;
  TaskStatusDialog(this.onDone,this.onUnDone);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            child: Text("Done"),
            onPressed: onDone,
          ),
          SizedBox(width: 10,),
          RaisedButton(
            child: Text("Not Done"),
            onPressed: onUnDone,
          ),
        ],
      ),
    );
  }
}
