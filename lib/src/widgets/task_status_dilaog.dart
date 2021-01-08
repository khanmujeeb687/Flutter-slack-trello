import 'package:flutter/material.dart';


class TaskStatusDialog extends StatelessWidget {
  VoidCallback onDone;
  VoidCallback onUnDone;
  TaskStatusDialog(this.onDone,this.onUnDone);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        RaisedButton(
          child: Text("Done"),
          onPressed: onDone,
        ),
        RaisedButton(
          child: Text("Un Done"),
          onPressed: onUnDone,
        ),
      ],
    );
  }
}
