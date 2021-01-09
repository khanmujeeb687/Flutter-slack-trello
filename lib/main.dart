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
import 'package:wively/src/widgets/custom_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

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
        theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          cursorColor: Colors.blue,
          appBarTheme: AppBarTheme().copyWith(
            iconTheme: IconThemeData(color: Colors.black),
            textTheme: TextTheme().copyWith(
              title: Theme.of(context).primaryTextTheme.title.copyWith(color: Colors.black)
            )
          )
        ),
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return PageRouteBuilder(
                  pageBuilder: (_, a1, a2) => AfterLaunchScreen(), settings: settings);
            case '/login':
              return PageRouteBuilder(
                  pageBuilder: (_, a1, a2) => LoginScreen(), settings: settings);
            case '/register':
              return CustomPageRoute.build(
                  builder: (_) => RegisterScreen(), settings: settings);
            case '/home':
              return PageRouteBuilder(
                  pageBuilder: (_, a1, a2) => HomeScreen(), settings: settings);
            case '/contact':
              return CustomPageRoute.build(
                  builder: (_) => ContactScreen(), settings: settings);
            case '/add-chat':
              return CustomPageRoute.build(
                  builder: (_) => AddChatScreen(settings.arguments), settings: settings, fullscreenDialog: true);
            case '/settings':
              return CustomPageRoute.build(
                  builder: (_) => SettingsScreen(), settings: settings);
            case '/room':
              return CustomPageRoute.build(
                  builder: (_) => RoomScreen(parentId: settings.arguments), settings: settings);
            case '/create_room':
              return CustomPageRoute.build(
                  builder: (_) => CreateRoom(roomId: settings.arguments), settings: settings);
            case '/RouteInfo':
              return CustomPageRoute.build(
                  builder: (_) => RoomInfo(settings.arguments), settings: settings);
            case '/TaskBoard':
              return CustomPageRoute.build(
                  builder: (_) => TaskBoardScreen(settings.arguments), settings: settings);
            case '/add_task':
              return CustomPageRoute.build(
                  builder: (_) => AddTask(settings.arguments), settings: settings);
            default:
              return CustomPageRoute.build(
                  builder: (_) => AfterLaunchScreen(), settings: settings);
          }
        },
      ),
    );
  }
}
