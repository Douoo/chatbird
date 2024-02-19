import 'package:chatbird/view/pages/login_page.dart';
import 'package:chatbird/view/pages/chat_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/user_prefs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? isLoginUserId;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final loginUserId = await UserPrefs.getLoginUserId();

    setState(() {
      isLoginUserId = (loginUserId != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (isLoginUserId == true) {
        return const ChatScreen();
      }
      if (isLoginUserId == false) {
        return const LoginPage();
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
