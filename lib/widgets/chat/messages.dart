import 'package:chatter/firebase_util.dart';
import 'package:chatter/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(FirebaseUtil.collectionChat)
          .orderBy(FirebaseUtil.attributeCreated, descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final chatDocs = snapshot.data?.docs;
        if (chatDocs == null || chatDocs.isEmpty) {
          return const Center(child: Text('No messages yet'));
        }
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) =>
              listViewItem(_auth.currentUser!.uid, chatDocs[index]),
          itemCount: chatDocs.length,
        );
      },
    );
  }

  Widget listViewItem(String loggedInUserId, dynamic chatDoc) {
    return MessageBubble(
        message: chatDoc[FirebaseUtil.attributeText],
        isMe: loggedInUserId == chatDoc[FirebaseUtil.attributeUserId],
        userName: chatDoc[FirebaseUtil.attributeUserName],
        key: ValueKey(chatDoc.id));
  }
}
