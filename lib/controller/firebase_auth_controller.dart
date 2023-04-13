import 'package:college_management_app/constants/common_snackbar.dart';
import 'package:college_management_app/provider/verification_id_otp_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseAuthController {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  signInWithPhoneNumber({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error);
        },
        codeSent: (verificationId, forceResendingToken) {
          Provider.of<VerificationIdOtpProvider>(
            context,
            listen: false,
          ).setVerificationId(
            verificationId: verificationId,
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (error) {
      print(error);
      CommonSnackbar.showErrorSnackbar(
        context: context,
        message: error.message.toString(),
      );
    } catch (error) {
      print(error);
      CommonSnackbar.showErrorSnackbar(
        context: context,
        message: error.toString(),
      );
    }
  }

  verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String otp,
  }) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      User? user =
          (await _firebaseAuth.signInWithCredential(phoneAuthCredential)).user;

      if (user != null) {
        // Normal Logic
      } else {
        throw "Something Went Wrong";
      }
    } on FirebaseAuthException catch (error) {
      CommonSnackbar.showErrorSnackbar(
        context: context,
        message: error.message.toString(),
      );
    } catch (error) {
      CommonSnackbar.showErrorSnackbar(
        context: context,
        message: error.toString(),
      );
    }
  }
}
