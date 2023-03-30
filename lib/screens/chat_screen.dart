import 'package:chatter/widgets/chat/messages.dart';
import 'package:chatter/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  final String pushTopic = 'chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<void> setupInteractedMessage() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) => {
      if (message != null) print('Initial firebase message: ${message.data}')
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground firebase message: ${message.data}');
    });
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
    FirebaseMessaging.instance.subscribeToTopic(widget.pushTopic);
  }

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
          underline: Container(),
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
