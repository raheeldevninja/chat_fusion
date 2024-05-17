import 'package:chat_fusion/helper/helper_functions.dart';
import 'package:chat_fusion/pages/home_page.dart';
import 'package:chat_fusion/services/auth_service.dart';
import 'package:chat_fusion/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String fullName = '';
  String email = '';
  String password = '';

  bool _isLoading = false;

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Chat Fusion',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Create your account now to chat and explore',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      Image.asset('assets/images/register.png'),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        onChanged: (val) {
                          setState(() {
                            fullName = val;
                          });
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter your full name";
                          } else {
                            return null;
                          }
                        },
                        decoration: textInputDecoration.copyWith(
                          label: const Text('Full Name'),
                          prefixIcon: const Icon(Icons.person),
                          prefixIconColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                        decoration: textInputDecoration.copyWith(
                          label: const Text('Email'),
                          prefixIcon: const Icon(Icons.email),
                          prefixIconColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        validator: (val) {
                          return val!.length < 6
                              ? "Password must be at least 6 characters"
                              : null;
                        },
                        decoration: textInputDecoration.copyWith(
                          label: const Text('Password'),
                          prefixIcon: const Icon(Icons.lock),
                          prefixIconColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                          ),
                          onPressed: () {
                            register();
                          },
                          child: const Text('Register'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Login Now',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _authService.registerUserWithEmailAndPassword(fullName, email, password).then((value) async {
        if (value == true) {

          //save data to shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUsername(fullName);
          await HelperFunctions.saveUserEmail(email);

          if(mounted) {
            nextReplaceScreen(context, const HomePage());
          }

        } else {

          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });

        }
      });

    }
  }
}
