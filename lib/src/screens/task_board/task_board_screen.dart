import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/task.dart';
import 'package:wively/src/screens/task_board/task_board_controller.dart';
import 'package:wively/src/screens/task_board/task_board_view.dart';
import 'package:wively/src/utils/screen_util.dart';
import 'package:wively/src/values/Colors.dart';
import 'package:wively/src/widgets/SimpleTextFormField.dart';
import 'package:wively/src/widgets/buttons.dart';
import 'package:wively/src/widgets/custom_app_bar.dart';
import 'package:wively/src/widgets/lottie_loader.dart';

class TaskBoardScreen extends StatefulWidget {
  static final routeName = '/TaskBoard';
  String roomId;

  TaskBoardScreen(this.roomId);

  @override
  _TaskBoardViewState createState() => _TaskBoardViewState();
}

class _TaskBoardViewState extends State<TaskBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('TaskBoard', style: TextStyle(color: EColors.white)),
      ),
      body: SafeArea(
          child: Container(
              height: ScreenUtil.height(context) - ScreenUtil.appBarHeight - 20,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: TaskBoardView(widget.roomId))),
    );
  }
}
