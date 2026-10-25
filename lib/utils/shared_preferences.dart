import 'package:shared_preferences/shared_preferences.dart';
import 'package:soft_khata_flutter/utils/app_constants.dart';

class Preferences {
  static setOnBoardingVisit(bool isVisit) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppConstants.ON_BOARDING_VISIT, isVisit);
  }

  static Future<bool> isOnBoardingVisit() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var isVisit = pref.getBool(AppConstants.ON_BOARDING_VISIT);
      return isVisit != null ? isVisit : false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static setIsLogin(bool isLogin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppConstants.IS_LOGIN, isLogin);
  }

  static Future<bool> isLoginUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var isLogin = pref.getBool(AppConstants.IS_LOGIN);
      return isLogin != null ? isLogin : false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
