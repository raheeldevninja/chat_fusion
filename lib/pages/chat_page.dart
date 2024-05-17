import 'package:chat_fusion/pages/group_info.dart';
import 'package:chat_fusion/services/database_service.dart';
import 'package:chat_fusion/widgets/message_tile.dart';
import 'package:chat_fusion/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.groupId,
    required this.groupName,
    required this.username,
    super.key});

  final String groupId;
  final String groupName;
  final String username;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final _messageController = TextEditingController();

  Stream<QuerySnapshot>? chats;
  String admin = '';

  @override
  void initState() {
    super.initState();

    getChatAndAdmin();
  }

  getChatAndAdmin() async {


    await DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });

    await DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName, style: const TextStyle(color: Colors.white,)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {

              nextScreen(context, GroupInfo(
                groupId: widget.groupId,
                groupName: widget.groupName,
                adminName: admin,
              ));

            },
          ),
        ],

      ),
      body: Stack(
        children: [

          chatMessages(),
          Container(
            width: double.maxFinite,
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Send a Message ...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                    ),
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return MessageTile(
              message: snapshot.data!.docs[index]['message'],
              sender: snapshot.data!.docs[index]['sender'],
              sentByMe: widget.username == snapshot.data!.docs[index]['sender'],
            );
          },
        ) : const Center(child: CircularProgressIndicator(color: Colors.white,),);
      },
    );
  }

  sendMessage() {

    if(_messageController.text.isNotEmpty) {

      Map<String, dynamic> chatMessageMap = {
        'message': _messageController.text,
        'sender': widget.username,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      _messageController.clear();
    }

  }

}
