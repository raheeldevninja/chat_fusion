import 'package:chat_fusion/helper/helper_functions.dart';
import 'package:chat_fusion/pages/chat_page.dart';
import 'package:chat_fusion/services/database_service.dart';
import 'package:chat_fusion/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final _searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;

  String username = '';
  User? user;

  bool hasUserJoined = false;

  @override
  void initState() {
    super.initState();

    getCurrentUsernameAndName();
  }

  getCurrentUsernameAndName() async {
    await HelperFunctions.getUsernameFromSharedPref().then((value) {
      setState(() {
        username = value!;
      });
    });

    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Search', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search groups ...',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    search();
                  },
                  icon: const Icon(Icons.search, color: Colors.white),
                ),

              ],
            ),
          ),

          isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor),) : groupList(),

        ],
      ),
    );
  }

  search() async {

    if(_searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      await DatabaseService().searchByName(_searchController.text.trim()).then((snapshot) {
        setState(() {
          isLoading = false;
          searchSnapshot = snapshot;
          hasUserSearched = true;
        });
      });


    }
  }

  groupList() {

    return hasUserSearched ?
    ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index) {

        return groupTile(
          username,
          searchSnapshot!.docs[index]['groupId'],
          searchSnapshot!.docs[index]['groupName'],
          searchSnapshot!.docs[index]['admin'],
        );

        })
        : const SizedBox();
  }

  ifUserHasJoined(String groupId, String groupName, String username) async {
    DatabaseService(uid: user!.uid).checkIfUserJoinedTheGroup(groupName, groupId, username).then((val) {
      setState(() {
        hasUserJoined = val;
      });
    });
  }

  groupTile(String username, String groupId, String groupName, String admin) {

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(groupName.substring(0, 1).toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      title: Text(groupName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
      subtitle: Text('Admin: ${_getName(admin)}', style: const TextStyle(color: Colors.black, fontSize: 13),),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, username, groupName);

          if(!hasUserJoined) {
            setState(() {
              hasUserJoined = !hasUserJoined;
            });

            showSnackBar(context, Colors.green, 'Successfully joined the group');

            Future.delayed(const Duration(seconds: 2), () {
              nextScreen(context, ChatPage(groupId: groupId, groupName: groupName, username: username));
            });

          }
          else {
            setState(() {
              hasUserJoined = !hasUserJoined;
            });

            showSnackBar(context, Colors.red, 'Left the group $groupName');
          }


        },
        child: hasUserJoined ?

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text('Joined', style: TextStyle(color: Colors.white),),
        ) :

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text('Join', style: TextStyle(color: Colors.white),),
        )
      ),

    );
  }

  String _getName(String value) {
    return value.substring(value.indexOf('_') + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf('_'));
  }


}
