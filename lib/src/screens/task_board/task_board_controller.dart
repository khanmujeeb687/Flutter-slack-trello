import 'dart:async';
import 'dart:io';

import 'package:wively/src/data/models/custom_error.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/repositories/register_repository.dart';
import 'package:wively/src/data/repositories/user_repository.dart';
import 'package:wively/src/screens/home/home_view.dart';
import 'package:wively/src/screens/login/login_view.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:wively/src/utils/socket_controller.dart';
import 'package:wively/src/utils/state_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class TaskBoardController extends StateControl {
  final BuildContext context;

  bool loading=true;

  TaskBoardController({
    @required this.context,
  }) {
    this.init();
  }

  void init() {

  }



  void fetchBoard() async{

  }

  @override
  void dispose() {
    super.dispose();
  }
}
