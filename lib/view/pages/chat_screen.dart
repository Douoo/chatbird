import 'dart:io';

import 'package:chatbird/view/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/chat_room_controller.dart';
import '../widgets/chat_text_field_widget.dart';
import '../widgets/message_bubble.dart';
import '../../models/message.dart';
import '../../styles/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgFieldController = TextEditingController();
  String msgText = '';
  List<Message> msgs = [];
  Color _buttonColor = kFadeGrey;

  @override
  void didChangeDependencies() {
    _msgFieldController.addListener(() {
      setState(() => _buttonColor =
          _msgFieldController.text.trim().isEmpty ? kFadeGrey : primaryColor);
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _msgFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('강남스팟'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => showLogoutDialog(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Message>>(
                stream: ChatRoom.getMessageStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Message> msgs = snapshot.data!.reversed.toList();
                    return ListView.builder(
                      itemCount: msgs.length,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      itemBuilder: (context, index) {
                        final msg = msgs[index];
                        return MessageBubble(
                          name: msg.senderNickname,
                          text: msg.content,
                          senderId: msg.senderId,
                          fromMe: msg.fromMe,
                          date: msg.createdAt,
                          avatar: msg.profileImg,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Something went wrong: ${snapshot.error}",
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
          ChatTextFieldWidget(
            chatTextFieldController: _msgFieldController,
            sendBtnColor: _buttonColor,
          )
        ],
      ),
    );
  }

  Future<dynamic> showLogoutDialog(BuildContext context) {
    const String logoutTitle = 'Are you sure?';
    const String logoutWarning = 'This will log you out of the chat room';
    return showDialog(
      context: context,
      builder: (context) {
        return Platform.isAndroid
            ? AlertDialog(
                backgroundColor: kBlackColor,
                title: const Text(
                  logoutTitle,
                  style: TextStyle(
                    color: kLightColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  logoutWarning,
                  textAlign: TextAlign.center,
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: renderLogoutOptions,
              )
            : CupertinoAlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('This will log you out of the chat room'),
                actions: renderLogoutOptions,
              );
      },
    );
  }

  List<Widget> get renderLogoutOptions {
    return [
      TextButton(
        onPressed: () {
          ChatRoom.logout().whenComplete(() => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false));
        },
        child: const Text(
          'LOGOUT',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'CANCEL',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      )
    ];
  }
}
