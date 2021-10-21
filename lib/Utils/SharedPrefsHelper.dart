
import 'package:shared_preferences/shared_preferences.dart';

class HelperExtension{
  static String sharedPreferenceUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferenceUserNameKey = 'USERNAME';
  static String sharedPreferenceUserEmailKey = 'USEREMAIL';
  static String sharedPreferenceUserIDKey = 'USERID';
  static String sharedPreferenceUserTheme = 'THEME';
  static bool darkMode = false;

  static Future<void> saveUserLoggedInSharedPrefs(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(sharedPreferenceUserLoggedInKey, isLoggedIn);
  }
  static Future<void> saveUserNameSharedPrefs(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(sharedPreferenceUserNameKey, username);
  }
  static Future<void> saveUserEmailSharedPrefs(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(sharedPreferenceUserLoggedInKey, email);
  }
  static Future<void> saveUserThemeSharedPrefs(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(sharedPreferenceUserTheme, theme);
  }

  static Future<bool> getUserLoggedInSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }
  static Future<String> getUserNameSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }
  static Future<String> getUserEmailSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserLoggedInKey);
  }
  static Future<String> getUserIDSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUserIDKey);
  }
  static Future<String> getUserThemeSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUserTheme);
  }
  static Future<void> saveSharedPreferenceDarkMode(bool v) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.setBool('darkMode', v);
  }

  static Future<void> saveSharedPreferenceUserID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.setString('USERID', id);
  }

  static Future<bool> getSharedPreferenceDarkModes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getBool('darkMode');
  }
}