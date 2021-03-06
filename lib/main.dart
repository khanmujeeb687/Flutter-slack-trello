import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:wively/src/data/providers/chats_provider.dart';
import 'package:wively/src/data/providers/uploads_provider.dart';
import 'package:wively/src/screens/after_launch_screen/after_launch_screen_view.dart';
import 'package:wively/src/values/themes/DarkRegular.dart';

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
        ChangeNotifierProvider(create: (_) => UploadsProvider(_)),
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
