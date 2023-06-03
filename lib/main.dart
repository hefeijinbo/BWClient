import 'package:flutter/material.dart';

import 'Home/home_page.dart';
import 'Network/bw_database.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Add this your main method.
  // used to show a webview title bar.
  if (runWebViewTitleBarWidget(args)) {
    return;
  }

  await BWDatabase.config();
  runApp(const MyApp());
}

var BWScreenWidth = 0.0;

var BWScreenHeight = 0.0;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '掘金',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '掘金'),
    );
  }
}
