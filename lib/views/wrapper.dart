import 'package:college_management_app/views/auth_views/phone_auth_view.dart';
import 'package:college_management_app/views/main_views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return const HomeView();
        } else {
          return const PhoneAuthView();
        }
      },
    );
  }
}
