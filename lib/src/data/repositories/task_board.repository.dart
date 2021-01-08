import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wively/src/data/models/custom_error.dart';
import 'package:wively/src/data/models/task.dart';
import 'package:wively/src/utils/custom_http_client.dart';
import 'package:wively/src/utils/my_urls.dart';


class TaskBoardRepository {
  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> getAllTasks(String boardId) async {
    try {
      Response response = await http.get('${MyUrls.ADD_TASK}/' + boardId);
      final List<dynamic> taskJson = jsonDecode(response.body)['tasks'];
      final List<Task> tasks =
      taskJson.map((user) => Task.fromJson(user)).toList();
      return tasks;

    } catch (e) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});

    }
  }


  Future<dynamic> createNewTask() async {
    try {
      Response response = await http.post(MyUrls.ADD_TASK);
      final dynamic taskJson = jsonDecode(response.body)['task'];
    } catch (e) {


    }


    Future<dynamic> editTask(taskId) async {
      try {
        Response response = await http.patch(MyUrls.ADD_TASK + '/' + taskId);
        final dynamic taskJson = jsonDecode(response.body)['task'];
      } catch (e) {


      }
    }
  }
}

