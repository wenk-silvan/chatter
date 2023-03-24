import 'package:chatter/widgets/chat/messages.dart';
import 'package:chatter/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Column(children: const [
        Expanded(child: Messages()),
        NewMessage(),
      ]),
    );
  }

  PreferredSizeWidget appBar(BuildContext ctx) {
    return AppBar(
      title: const Text('Chatter'),
      actions: [
        DropdownButton(
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(ctx).primaryIconTheme.color,
          ),
          items: [_logoutMenuItem()],
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
