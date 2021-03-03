import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/local_database/db_provider.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/screens/home/home_view.dart';
import 'package:wively/src/screens/login/login_view.dart';
import 'package:wively/src/utils/custom_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/utils/navigation_util.dart';
import 'package:wively/src/utils/screen_util.dart';

import '../../utils/NotificationsHandler.dart';

class AfterLaunchScreen extends StatefulWidget {
  @override
  _AfterLaunchScreenState createState() => _AfterLaunchScreenState();
}

class _AfterLaunchScreenState extends State<AfterLaunchScreen> {
  static bool isInitialized=false;
  static NotificationsHandler notificationsHandler=new NotificationsHandler();

  void verifyUserLoggedInAndRedirect() async {
    notificationsHandler.initializeFcmNotification(context);
    Widget destination = HomeScreen();
    String token = await CustomSharedPreferences.get('token');
    if (token == null) {
      destination = LoginScreen();
    }
    await Firebase.initializeApp();
    Timer.run(() {
      // In case user is already logged in, go to home_screen
      // otherwise, go to login_screen
      NavigationUtil.replace(context, destination);
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
    if(!isInitialized){
      isInitialized=true;
      Provider.of<ChatsProvider>(context).setAllUnSentMessages();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
