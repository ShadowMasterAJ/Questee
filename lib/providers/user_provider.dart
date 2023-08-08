import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isVerified = false;
  
  bool get isVerified => _isVerified;

  // Function to update the verification status locally
  void updateVerificationStatus(bool verified) {
    _isVerified = verified;
    notifyListeners();
  }
}
