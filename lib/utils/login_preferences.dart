import 'package:prefs/prefs.dart';
import 'app_constants.dart';

class LoginPreferences {

  static setLoggedIn(bool isLogin) {
    Prefs.setBool(AppConstants.IS_LOGIN, isLogin);
  }

  static Future<bool> isLoggedIn() {
    return Prefs.getBoolF(AppConstants.IS_LOGIN);
  }

  static setUserId(String id) async {
    Prefs.setString(AppConstants.ID, id);
  }

  static String getUserId() {
    return Prefs.getString(AppConstants.ID);
  }


  static setUserName(String name) async {
    Prefs.setString(AppConstants.NAME, name);
  }

  static String getUserName() {
    return Prefs.getString(AppConstants.NAME);
  }

  static setUserEmail(String email) async {
    Prefs.setString(AppConstants.EMAIL, email);
  }

  static String getUserEmail() {
    return Prefs.getString(AppConstants.EMAIL);
  }

  static setUserNumber(String number) async {
    Prefs.setString(AppConstants.NUMBER, number);
  }

  static String getUserNumber() {
    return Prefs.getString(AppConstants.NUMBER);
  }

  static setBusinessName(String name) async {
    Prefs.setString(AppConstants.BUSINESSNAME, name);
  }

  static String getBusinessName() {
    return Prefs.getString(AppConstants.BUSINESSNAME);
  }

  static setBusinessCat(String cat) async {
    Prefs.setString(AppConstants.BUSINESSCAT, cat);
  }

  static String getBusinessCat() {
    return Prefs.getString(AppConstants.BUSINESSCAT);
  }
}