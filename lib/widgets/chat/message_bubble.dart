import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {required this.message,
      required this.userName,
      required this.isMe,
      required this.userImageUrl,
      required this.key});

  final String message;
  final String userName;
  final bool isMe;
  final String userImageUrl;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color:
                    isMe ? Colors.grey.shade300 : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(!isMe ? 0 : 12),
                  bottomRight: Radius.circular(isMe ? 0 : 12),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  messageBubbleUserName(context),
                  messageBubbleText(context),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: CircleAvatar(backgroundImage: NetworkImage(userImageUrl)),
        )
      ],
    );
  }

  Widget messageBubbleUserName(BuildContext context) {
    return Text(
      userName,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget messageBubbleText(BuildContext context) {
    return Text(
      message,
      textAlign: isMe ? TextAlign.end : TextAlign.start,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
    );
  }
}
