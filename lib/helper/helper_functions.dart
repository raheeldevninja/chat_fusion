import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

  //keys
  static String userLoggedInKey = "USERLOGGEDINKEY";
  static String usernameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";


  //saving data to shared preferences
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUsername(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(usernameKey, username);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }


  //getting data from shared preferences

  static Future<bool> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getBool(userLoggedInKey) ?? false;
  }

  static Future<String> getUsernameFromSharedPref() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(usernameKey) ?? "";
  }

  static Future<String> getUserEmailFromSharedPref() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey) ?? "";
  }

}