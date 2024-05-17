import 'package:chat_fusion/pages/chat_page.dart';
import 'package:chat_fusion/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  const GroupTile({
    required this.username,
      required this.groupId,
      required this.groupName,
      super.key,
  });

  final String username;
  final String groupId;
  final String groupName;

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          widget.groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      title: Text(
        widget.groupName,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Join the conversation as ${widget.username}',
        style: const TextStyle(fontSize: 13, color: Colors.black),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      onTap: () {
        print('ontap');

        nextScreen(
          context,
          ChatPage(
            groupId: widget.groupId,
            groupName: widget.groupName,
            username: widget.username,
          ),
        );
      },
    );
  }
}
