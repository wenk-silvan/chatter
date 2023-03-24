import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseUtil {
  // Users
  static const collectionUsers = 'users';
  static const attributeUserName = 'username';
  static const attributeEmail = 'email';

  // Chat
  static const collectionChat = 'chat';
  static const attributeText = 'text';
  static const attributeCreated = 'createdAt';
  static const attributeUserId = 'userId';

  static showFirebaseError(FirebaseException error, BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(
        error.message ?? 'An error occurred, please check credentials.',
      ),
      backgroundColor: Theme.of(ctx).errorColor,
    ));
  }
}
