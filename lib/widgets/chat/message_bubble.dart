import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.userName, this.isMe, {required this.key});

  final String userName;
  final String message;
  final bool isMe;
  final Key key;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Colors.grey[300]
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 4,
          ),
          child: Column(
            crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
            children: [
             
                     Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                         color: isMe ? Colors.black : Colors.white,
                      ),
                   
                     ),
              Text(
                message,
                style: TextStyle(
                    color: isMe ? Colors.black : Colors.white, fontSize: 15),
                    textAlign: isMe? TextAlign.end:TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
