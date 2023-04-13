import 'package:flutter/material.dart';

class VerificationIdOtpProvider extends ChangeNotifier {
  String _verificationId = "";

  setVerificationId({required String verificationId}) {
    _verificationId = verificationId;
    notifyListeners();
  }

  String get verificationId => _verificationId;
}