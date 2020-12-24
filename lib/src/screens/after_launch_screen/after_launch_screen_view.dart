import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wively/src/data/local_database/db_provider.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/screens/home/home_view.dart';
import 'package:wively/src/screens/login/login_view.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AfterLaunchScreen extends StatefulWidget {
  @override
  _AfterLaunchScreenState createState() => _AfterLaunchScreenState();
}

class _AfterLaunchScreenState extends State<AfterLaunchScreen> {
  void verifyUserLoggedInAndRedirect() async {
    String routeName = HomeScreen.routeName;
    String token = await CustomSharedPreferences.get('token');
    if (token == null) {
      routeName = LoginScreen.routeName;
    }
    await Firebase.initializeApp();
    Timer.run(() {
      // In case user is already logged in, go to home_screen
      // otherwise, go to login_screen
      Navigator.of(context).pushReplacementNamed(routeName);
    });
  }

  @override
  void initState() {
    super.initState();
    DBProvider.db.database;
    verifyUserLoggedInAndRedirect();
  }

  @override
  void didChangeDependencies() {
    Provider.of<ChatsProvider>(context).updateChats();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
