import 'package:chat_fusion/pages/home_page.dart';
import 'package:chat_fusion/services/database_service.dart';
import 'package:chat_fusion/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  const GroupInfo({
    required this.groupId,
    required this.groupName,
    required this.adminName,
    super.key,
  });

  final String groupId;
  final String groupName;
  final String adminName;

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {

  Stream? members;

  @override
  void initState() {
    super.initState();

    getMembers();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Group Info',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [

          IconButton(
            onPressed: () {

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Exit'),
                    content: const Text('Are you sure you want to exit from group?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {

                          DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                              .toggleGroupJoin(widget.groupId, _getName(widget.adminName), widget.groupName).whenComplete(() {

                                nextReplaceScreen(context, const HomePage());

                          });

                       },
                        child: const Text('Exit'),
                      ),
                    ],
                  );
                },
              );

            },
            icon: Icon(Icons.exit_to_app),
          ),

        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
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
                  'Admin: ${_getName(widget.adminName)}',
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),

            ),
            membersList(),
          ],
        ),
      ),
    );
  }

  String _getName(String value) {
    return value.substring(value.indexOf('_') + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf('_'));
  }


  membersList() {
    return StreamBuilder(stream: members,
        builder: (context, AsyncSnapshot snapshot) {

            if(snapshot.hasData) {

              if(snapshot.data['members'] != null && snapshot.data['members'].length > 0) {

                return ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            _getName('${ snapshot.data['members'][index]}').substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        title: Text(
                          _getName(snapshot.data['members'][index]),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          getId(snapshot.data['members'][index]),
                          style: const TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ),
                    );
                  },
                );

              }
              else {
                return const Center(child: Text('No members'));
              }

            }
            else {
              return Center(
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),
              );
            }
        });
  }

}
