import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  final CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');

  //save user data
  Future saveUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'groups': [],
      'profilePic': '',
      'uid': uid,
    });
  }

  //get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).get();

    return snapshot;
  }

  //get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }


  //create group
  Future createGroup(String username, String id, String groupName) async {

    DocumentReference groupDocumentReference = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': '${id}_$username',
      'members': [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': '',
    });

    await groupDocumentReference.update({
      'members': FieldValue.arrayUnion(['${uid}_$username']),
      'groupId': groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);

    return await userDocumentReference.update({
      'groups': FieldValue.arrayUnion(['${groupDocumentReference.id}_$groupName']),
    });

  }

  //get chats
  getChats(String groupId) async {
    return groupCollection.doc(groupId).collection('messages').orderBy('time').snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot groupDocumentSnapshot = await groupDocumentReference.get();

    return groupDocumentSnapshot['admin'];
  }

  //get group members
  getGroupMembers(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  //search group
  searchByName(String groupName) async {
    return groupCollection.where('groupName', isEqualTo: groupName).get();
  }

  Future<bool> checkIfUserJoinedTheGroup(String groupName, String groupId, String username) async {

    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = documentSnapshot['groups'];

    if(groups.contains('${groupId}_$groupName')) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleGroupJoin(String groupId, String username, String groupName) async {

    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot userDocumentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = userDocumentSnapshot['groups'];

    if(groups.contains('${groupId}_$groupName')) {
      await userDocumentReference.update({
        'groups': FieldValue.arrayRemove(['${groupId}_$groupName']),
      });

      await groupDocumentReference.update({
        'members': FieldValue.arrayRemove(['${uid}_$username']),
      });

    } else {
      await userDocumentReference.update({
        'groups': FieldValue.arrayUnion(['${groupId}_$groupName']),
      });

      await groupDocumentReference.update({
        'members': FieldValue.arrayUnion(['${uid}_$username']),
      });

    }
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {

    await groupCollection.doc(groupId).collection('messages').add(chatMessageData);

    groupCollection.doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

}