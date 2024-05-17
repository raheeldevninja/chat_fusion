import 'package:chat_fusion/helper/helper_functions.dart';
import 'package:chat_fusion/pages/auth/login_page.dart';
import 'package:chat_fusion/pages/home_page.dart';
import 'package:chat_fusion/services/auth_service.dart';
import 'package:chat_fusion/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.username,
    required this.email,
    super.key});

  final String username;
  final String email;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              children: [
                Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.grey[700],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const Divider(height: 2),
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text(
                      'Groups', style: TextStyle(color: Colors.black)),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  onTap: () {
                    Navigator.pop(context);

                    nextScreen(context, const HomePage());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text(
                      'Profile', style: TextStyle(color: Colors.black)),
                  selectedColor: Theme
                      .of(context)
                      .primaryColor,
                  selected: true,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  onTap: () {

                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text(
                      'Logout', style: TextStyle(color: Colors.black)),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {

                                await HelperFunctions.saveUserLoggedInStatus(false);
                                await  HelperFunctions.saveUsername("");
                                await HelperFunctions.saveUserEmail("");

                                _authService.signOut().whenComplete(() {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()),
                                        (route) => false,
                                  );
                                });
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

              ],
            )),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Profile', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 200, color: Colors.grey[700],),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Full Name: ', style: TextStyle(fontWeight: FontWeight.bold),),
                Text(widget.username),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Email: ', style: TextStyle(fontWeight: FontWeight.bold),),
                Text(widget.email),
              ],
            ),
          ],
        ),
      )
    );
  }
}
