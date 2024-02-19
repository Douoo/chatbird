import 'package:chatbird/models/message.dart';
import 'package:chatbird/utils/user_prefs.dart';
import 'package:flutter/widgets.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String appID = 'BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF';
const String channelURL =
    'sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211';

class ChatRoom {
  static Future<void> init([String? userId]) async {
    await SendbirdChat.init(
      appId: appID,
      options: SendbirdChatOptions(useCollectionCaching: true),
    );

    try {
      // connect sendbird server with user id
      final currentUserId = userId ?? await UserPrefs.getLoginUserId();
      if (currentUserId == null) {
        return;
      }
      await SendbirdChat.connect(currentUserId);
      joinOpenChannel();
    } catch (e) {
      debugPrint('Something went wrong: $e');
      // handle error
    }
  }

  static Future<void> joinOpenChannel() async {
    OpenChannel channel = await OpenChannel.getChannel(channelURL);
    await channel.enter();
  }

  static Stream<List<Message>> getMessageStream() async* {
    OpenChannel channel = await OpenChannel.getChannel(channelURL);
    final currentUser = SendbirdChat.currentUser!;
    final params = MessageListParams()
      ..inclusive = true
      ..previousResultSize = 35
      ..nextResultSize = 0
      ..reverse = false;

    // Infinite loop to continuously fetch messages
    while (true) {
      final msgs = await channel.getMessagesByTimestamp(
          double.maxFinite.toInt(), params);
      List<Message> msgContents = [];
      for (RootMessage msg in msgs) {
        if (msg is UserMessage) {
          Message msgContent = Message(
            id: msg.rootId,
            content: msg.message,
            senderId: msg.sender!.userId,
            createdAt: DateTime.fromMillisecondsSinceEpoch(msg.createdAt),
            senderNickname: msg.sender?.nickname,
            fromMe: msg.sender!.userId == currentUser.userId,
            profileImg: msg.sender?.profileUrl,
          );
          msgContents.add(msgContent);
        }
      }

      // Yield the list of messages
      yield msgContents;

      // Sleep for some time before fetching messages again
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  static Future<void> sendMessage(String message) async {
    OpenChannel channel = await OpenChannel.getChannel(channelURL);
    final params = UserMessageCreateParams(message: message);
    channel.sendUserMessage(params);
  }

  static Future<void> login(String userId) async {
    await SendbirdChat.connect(userId, nickname: userId);
    await UserPrefs.setLoginUserId();
  }

  static Future<void> logout() async {
    try {
      await SendbirdChat.disconnect();
      final pref = await SharedPreferences.getInstance();
      pref.clear();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
