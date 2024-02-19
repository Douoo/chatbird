// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'dart:math';

import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> randomNames = [
  'Alex',
  'Taylor',
  'Jordan',
  'Casey',
  'Avery',
  'Morgan',
  'Riley',
  'Cameron',
  'Blake',
  'Reese',
];

class UserPrefs {
  static const String prefLoginUserId = 'prefLoginUserId';

  static String generateRandomId() {
    // Select a random name from the list
    final random = Random();
    final randomIndex = random.nextInt(randomNames.length);
    final randomName = randomNames[randomIndex];

    // Append a random number to the name to create a unique ID
    final randomNumber = random.nextInt(1000); // Adjust as needed
    final nameId = '$randomName$randomNumber';

    return nameId;
  }

  static Future<bool> setLoginUserId() async {
    bool result = false;
    final prefs = await SharedPreferences.getInstance();
    final currentUser = SendbirdChat.currentUser;
    if (currentUser != null) {
      result = await prefs.setString(prefLoginUserId, currentUser.userId);
    }
    return result;
  }

  static Future<String?> getLoginUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefLoginUserId);
  }

  static Future<bool> removeLoginUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(prefLoginUserId);
  }

  static Future<bool> setUserPushOn(bool isPushOn) async {
    bool result = false;
    final prefs = await SharedPreferences.getInstance();
    final currentUser = SendbirdChat.currentUser;
    if (currentUser != null) {
      result = await prefs.setBool('${currentUser.userId}_pushOn', isPushOn);
    }
    return result;
  }

  static Future<bool?> getUserPushOn() async {
    bool? result;
    final prefs = await SharedPreferences.getInstance();
    final currentUser = SendbirdChat.currentUser;
    if (currentUser != null) {
      result = prefs.getBool('${currentUser.userId}_pushOn');
    }
    return result;
  }

  static Future<bool> removeUserPushOn() async {
    bool result = false;
    final prefs = await SharedPreferences.getInstance();
    final currentUser = SendbirdChat.currentUser;
    if (currentUser != null) {
      result = await prefs.remove('${currentUser.userId}_pushOn');
    }
    return result;
  }
}
