import 'package:shared_preferences/shared_preferences.dart';

class GlobalSharedPreference {
  static const userId = 'user_id';
  static const userName = 'username';
  static const userEmail = 'user_email';
  static const userImage = 'user_image';
  static const scrolltype = 'scrolltype';
   static const initScrolltype = 'initScrolltype';
  static const googleFont = 'googleFont';
  static const oneTimeLogin = 'oneTimeLogin';
    static const doNotShowAlertDialogAgain = 'doNotShowAlertDialogAgain';

  static setUserID(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(userId, value);
  }

  static Future<String> getUserID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(
          userId,
        ) ??
        '';
  }

  static setUserName(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(userName, value);
  }

  static Future<String> getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(
          userName,
        ) ??
        '';
  }

  static setUserEmail(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(userEmail, value);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(
          userEmail,
        ) ??
        '';
  }

  static setUserImage(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(userImage, value);
  }

  static Future<String> getUserImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(
          userImage,
        ) ??
        '';
  }

  static Future<bool> clearUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(userEmail);
  }

  static Future<bool> clearUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(userId);
  }

  static Future<bool> clearUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(userName);
  }

  static Future<bool> clearUserImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(userImage);
  }

  static setScrollType(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(scrolltype, value);
  }

  static Future<String> getScrollType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(
          scrolltype,
        ) ??
        '';
  }

  static setInitScrolltype(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(initScrolltype, value);
  }

  static Future<String> getInitScrolltype() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(
          initScrolltype,
        ) ??
        '';
  }


  static setTempGoogleFont(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(googleFont, value);
  }

  static Future<String> getTempGoogleFont() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(
          googleFont,
        ) ??
        '';
  }

  static Future<bool> clearTempGoogleFont() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(googleFont);
  }

  static setOneTimeLogin(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(oneTimeLogin, value);
  }

  static Future<bool> getOneTimeLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(
          oneTimeLogin,
        ) ??
        false;
  }

  static Future<bool> clearOneTimeLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(oneTimeLogin);
  }

  static setDoNotShowAlertDialogAgain(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(doNotShowAlertDialogAgain, value);
  }

  static Future<bool> getDoNotShowAlertDialogAgain() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(
          doNotShowAlertDialogAgain,
        ) ??
        false;
  }

  static Future<bool> clearDoNotShowAlertDialogAgain() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(doNotShowAlertDialogAgain);
  }
}
