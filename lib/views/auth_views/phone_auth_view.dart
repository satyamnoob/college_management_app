import 'package:college_management_app/controller/firebase_auth_controller.dart';
import 'package:college_management_app/provider/verification_id_otp_provider.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});

  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _formKeyPhone = GlobalKey<FormState>();
  bool _showOtpField = false;

  sendOtp() async {
    if (_formKeyPhone.currentState!.validate()) {
      setState(() {
        _showOtpField = true;
      });
      print(_phoneController.text);
      await FirebaseAuthController().signInWithPhoneNumber(
        context: context,
        phoneNumber: _phoneController.text,
      );
    }
  }

  verifyOtp() async {
    String verificationId = Provider.of<VerificationIdOtpProvider>(
      context,
      listen: false,
    ).verificationId;
    await FirebaseAuthController().verifyOTP(
      context: context,
      otp: _otpController.text,
      verificationId: verificationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 100),
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Login With Phone...",
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Form(
                key: _formKeyPhone,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = RegExp(pattern);
                        if (value!.isEmpty) {
                          return 'Please enter mobile number';
                        } else if (!regExp.hasMatch(value)) {
                          return 'Please enter valid mobile number';
                        }
                        return null;
                      },
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        hintText: "Enter Phone Number",
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.redAccent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.blue,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: !_showOtpField,
                      child: ElevatedButton(
                        onPressed: () {
                          sendOtp();
                        },
                        child: const Text("Send OTP"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Column(
                  children: [
                    Visibility(
                      visible: _showOtpField,
                      child: Pinput(
                        length: 6,
                        controller: _otpController,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: _showOtpField,
                      child: ElevatedButton(
                        onPressed: () {
                          verifyOtp();
                        },
                        child: const Text("Verify OTP"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
