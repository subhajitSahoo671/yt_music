import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yt_music/presentation/auth/pages/signup.dart';
import 'package:yt_music/presentation/home/pages/root.dart';
import 'package:yt_music/presentation/intro/pages/get_started.dart';
import 'package:yt_music/presentation/splash/pages/splash.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(), 
    builder: (context, snapshot) {
       if (snapshot.connectionState == ConnectionState.waiting) {
      return const SplashPage();
    }

    //user is logged in
       if (snapshot.hasData) {
        return RootPage();
      }

      //user is not logged in    
      else {
        return GetStartedPage();
      }
    },);
  }
}