import 'package:chatter/firebase_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  final _store = FirebaseFirestore.instance;
  var _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final userData = await _store
          .collection(FirebaseUtil.colUsers)
          .doc(currentUser.uid)
          .get();
      await FirebaseFirestore.instance.collection('chat').add({
        FirebaseUtil.attrText: _enteredMessage,
        FirebaseUtil.attrCreated: Timestamp.now(),
        FirebaseUtil.attrUserId: currentUser.uid,
        FirebaseUtil.attrUserName: userData[FirebaseUtil.attrUserName],
        FirebaseUtil.attrImageUrl: userData[FirebaseUtil.attrImageUrl],
      });
      _controller.clear();
    } on FirebaseException catch (err) {
      FirebaseUtil.showFirebaseError(err, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
