import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _showPassword = true;
  // ignore: prefer_final_fields
  Widget _buttonChild = const Text(
    "Login",
    style: TextStyle(color: Color(0xFF1C4274), fontFamily: "Muli-Bold"),
  );
  bool _failed = false;

  bool get showPassword => _showPassword;
  Widget get buttonChild => _buttonChild;
  bool get failed => _failed;

  void showsPassword() {
    if (_showPassword == true) {
      _showPassword = false;
    } else {
      _showPassword = true;
    }
    notifyListeners();
  }

  void setFailed() {
    _failed = true;
    notifyListeners();
  }

  void setFailedFalse() {
    _failed = false;
    notifyListeners();
  }

  void setButtonChild() {
    _buttonChild = const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ));
    notifyListeners();
  }

  void setButtonChildNormal() {
    _buttonChild = const Text(
      "Login",
      style: TextStyle(color: Color(0xFF1C4274), fontFamily: "Muli-Bold"),
    );
  }
}
