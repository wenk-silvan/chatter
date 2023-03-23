import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chats/jITu5L9ynj7wmJRo2E53/messages')
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (ctx, index) =>
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(docs[index]['text']),
                    ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('chats/jITu5L9ynj7wmJRo2E53/messages')
                .add({'text': 'Sample text'});
          },
        ));
  }

  PreferredSizeWidget appBar(BuildContext ctx) {
    return AppBar(
      title: const Text('Chatter'),
      actions: [
        DropdownButton(
          icon: Icon(
            Icons.more_vert,
            color: Theme
                .of(ctx)
                .primaryIconTheme
                .color,
          ),
          items: [ _logoutMenuItem() ],
          onChanged: (itemIdentifier) {
            if (itemIdentifier == MenuItem.logout) {
              FirebaseAuth.instance.signOut();
            }
          },
        )
      ],
    );
  }

  DropdownMenuItem _logoutMenuItem() {
    return DropdownMenuItem(
      value: MenuItem.logout,
      child: Row(children: const [
        Icon(Icons.exit_to_app),
        SizedBox(width: 8),
        Text('logout'),
      ]),
    );
  }
}

enum MenuItem {
  logout,
}
