import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/screens/add_chat/add_chat_view.dart';
import 'package:wively/src/screens/after_launch_screen/after_launch_screen_view.dart';
import 'package:wively/src/screens/contact/contact_view.dart';
import 'package:wively/src/screens/home/home_view.dart';
import 'package:wively/src/screens/login/login_view.dart';
import 'package:wively/src/screens/register/register_view.dart';
import 'package:wively/src/screens/room/create_room.dart';
import 'package:wively/src/screens/room/room_info.dart';
import 'package:wively/src/screens/room/room_view.dart';
import 'package:wively/src/screens/settings/settings_view.dart';
import 'package:wively/src/screens/task_board/add_task_view.dart';
import 'package:wively/src/screens/task_board/task_board_view.dart';
import 'package:wively/src/values/themes/DarkRegular.dart';
import 'package:wively/src/widgets/custom_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() => runApp(Phoenix(child: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Talk to me',
        theme: DarkRegular.getTheme(context),
        home: AfterLaunchScreen(),
      ),
    );
  }
}
