import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseUtil {
  // Users
  static const colUsers = 'users';
  static const attrUserName = 'username';
  static const attrEmail = 'email';
  static const attrImageUrl = 'imageUrl';

  // Chat
  static const colChat = 'chat';
  static const attrText = 'text';
  static const attrCreated = 'createdAt';
  static const attrUserId = 'userId';

  static showFirebaseError(FirebaseException error, BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(
        error.message ?? 'An error occurred, please check credentials.',
      ),
      backgroundColor: Theme.of(ctx).errorColor,
    ));
  }
}
