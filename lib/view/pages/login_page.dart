// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:chatbird/controller/chat_room_controller.dart';
import 'package:chatbird/view/pages/chat_screen.dart';
import 'package:chatbird/styles/colors.dart';
import 'package:chatbird/styles/text_field.dart';
import 'package:chatbird/utils/user_prefs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final textEditingController = TextEditingController();
  bool creatingUserId = false;
  bool generatingRandomId = false;

  Future<void> _login(String userId, {bool? isRandomUserId}) async {
    if (isRandomUserId == true) {
      //For indicating the progress of generate random id
      setState(() => generatingRandomId = true);
    } else {
      //For indicating the progress of creating user id
      setState(() => creatingUserId = true);
    }
    try {
      //Logs the user to the chat room using the given userId
      await ChatRoom.login(userId);
      ChatRoom.joinOpenChannel().whenComplete(
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        creatingUserId = false;
        generatingRandomId = false;
      });
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to \nSendBird Chat',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Enter a user name that you like. This will be used as an identifier and nick name when you join the chat',
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: roundBorder,
                focusedBorder: roundBorder.copyWith(
                    borderSide: const BorderSide(color: primaryColor)),
                labelText: 'User ID',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: creatingUserId
                  ? null
                  : () async {
                      if (textEditingController.value.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Enter a user id you like',
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.redAccent,
                        );
                      } else {
                        _login(textEditingController.value.text);
                      }
                    },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: primaryColor,
                  foregroundColor: kLightColor,
                  textStyle: const TextStyle(fontSize: 16),
                  disabledBackgroundColor: Colors.grey),
              child: creatingUserId
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Continue'),
            ),
            const SizedBox(
              height: 16,
            ),
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    color: kFadeGrey,
                    thickness: 1.5,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'OR',
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: kFadeGrey,
                    thickness: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            OutlinedButton(
              onPressed: () {
                final randomId = UserPrefs.generateRandomId();
                _login(randomId, isRandomUserId: true);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: kLightColor,
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: generatingRandomId
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Generate Random Profile'),
            )
          ],
        ),
      ),
    );
  }
}
