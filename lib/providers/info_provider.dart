import 'package:flutter/foundation.dart';


class InfoProvider with ChangeNotifier {

  String buttonStringValue = 'Login';
  bool isLoading = false;
  bool isSwitched = false;
  bool isUploaded = false;
  bool passwordVisible = false;
  bool hasError = false;
  bool isImagePicked = false;
  bool isImageSendToServer = false;
  bool changesToServerMade = false;
  bool isApproved = false;
  bool isFollowRequestSent = false;
  bool get isLoadingStatus => isLoading;
  bool doNotShowAlertDialogAgain = false;

 void toggleSentFriend() {
    isFollowRequestSent = !isFollowRequestSent;
    notifyListeners();
  }
 
  void changeToRegistration() {
    buttonStringValue = 'Register';
    notifyListeners();
  }

  void changeToLogin() {
    buttonStringValue = 'Login';
    notifyListeners();
  }

  void toggleSwitch() {
    isSwitched = !isSwitched;
    notifyListeners();
  }

  void toggleIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void toggleViewPassword() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void toggleHasError() {
    hasError = true;
    notifyListeners();
  }

  void toggleImagePicked() {
    isImagePicked = true;
    notifyListeners();
  }

  void toggleImageUpdated() {
    isImageSendToServer = true;
    notifyListeners();
  }

  void toggleChangesToServer() {
    changesToServerMade = true;
    notifyListeners();
  }

   void toggleIsApproved() {
    isApproved = true;
    notifyListeners();
  }

  void toggleIsNotApproved() {
    isApproved = false;
    notifyListeners();
  }

 

}
