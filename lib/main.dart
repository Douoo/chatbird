import 'dart:async';

import 'package:chatbird/controller/chat_room_controller.dart';
import 'package:chatbird/styles/theme_data.dart';
import 'package:chatbird/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (errorDetails) {
        debugPrint('[FlutterError] ${errorDetails.stack}');
        Fluttertoast.showToast(
          msg: '[FlutterError] ${errorDetails.stack}',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
        );
      };

      await ChatRoom.init();
      runApp(const MyApp());
    },
    (error, stackTrace) async {
      debugPrint('[Error] $error\n$stackTrace');
      Fluttertoast.showToast(
        msg: '[Error] $error',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sendbird Chat',
      home: const HomePage(),
      theme: ThemeStyle.appTheme(),
    );
  }
}
