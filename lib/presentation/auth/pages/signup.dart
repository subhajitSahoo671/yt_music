// import 'dart:math';
// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yt_music/common/widgets/button/basic_app_bar.dart';
import 'package:yt_music/common/widgets/button/basic_app_button.dart';
import 'package:yt_music/common/widgets/hero_widgets/app_logo_widget.dart';
import 'package:yt_music/data/models/auth/create_user_req.dart';
import 'package:yt_music/domain/usecases/auth/signup.dart';
import 'package:yt_music/presentation/auth/pages/signin.dart';
// import 'package:yt_music/presentation/home/pages/home.dart';
import 'package:yt_music/presentation/home/pages/root.dart';
import 'package:yt_music/service_locator.dart';
//import 'package:yt_music/core/configs/theme/app_colors.dart';
//import 'package:yt_music/core/configs/assets/app_vectors.dart';
//import 'package:flutter_svg/svg.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: _signInText(),
      persistentFooterButtons: [_signInText(context)],
      persistentFooterDecoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withAlpha(2),
            blurRadius: 5,
            offset: Offset(0, -5),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Colors.purpleAccent.withAlpha(200),
            width: 0.5,
          ),
        ),
      ),
      appBar: BasicAppBar(title: AppLogoWidget(width: 120, height: 45)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              _registerText(),
              SizedBox(height: 40),
              _fullNameField(context),
              SizedBox(height: 20),
              _emailField(),
              SizedBox(height: 20),
              _passwordField(),
              SizedBox(height: 40),
              BasicAppButton(
                onPressed: () async {
                  var result = await sl<SignupUseCase>().call(
                    params: CreateUserReq(
                      fullName: _fullName.text.toString(),
                      email: _email.text.toString(),
                      password: _password.text.toString(),
                    ),
                  );

                  result.fold(
                    (l) {
                      var snackBar = SnackBar(content: Text(l));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    (r) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RootPage();
                          },
                        ),
                        (route) => false,
                      );
                    },
                  );
                },
                title: "Create Account",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerText() {
    return Text(
      "Register",
      style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
      controller: _fullName,
      decoration: InputDecoration(
        labelText: "Full Name",
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _email,
      decoration: InputDecoration(labelText: "Enter Email"),
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _password,
      decoration: InputDecoration(labelText: "Password"),
    );
  }

  Widget _signInText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return  SigninPage();
                  },
                ),
              );
            },
            child: Text(
              "Sign In",
              style: TextStyle(
                fontSize: 14,
                //color: AppColors.primary.withValues(blue: 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
