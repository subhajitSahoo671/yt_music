import 'package:flutter/material.dart';

import 'package:yt_music/common/widgets/button/basic_app_bar.dart';
import 'package:yt_music/common/widgets/button/basic_app_button.dart';
import 'package:yt_music/common/widgets/hero_widgets/app_logo_widget.dart';
import 'package:yt_music/data/models/auth/signin_user_req.dart';
import 'package:yt_music/domain/usecases/auth/signin.dart';
import 'package:yt_music/presentation/auth/pages/signup.dart';
// import 'package:yt_music/presentation/home/pages/home.dart';
import 'package:yt_music/presentation/home/pages/root.dart';
import 'package:yt_music/service_locator.dart';

class SigninPage extends StatefulWidget {
   const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final  TextEditingController _email = TextEditingController();
  final  TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: _signInText(),
      persistentFooterButtons: [_signInFooterText(context)],
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
              SizedBox(height: 50),
              _signinText(),
              SizedBox(height: 40),
              _emailField(context),
              SizedBox(height: 20),
              _passwordField(),
              SizedBox(height: 40),
              BasicAppButton(onPressed: () async{
                var result = await sl<SigninUseCase>().call(
                  params: SigninUserReq(
                    email: _email.text.toString(), 
                    password: _password.text.toString())
                );

                if (!mounted) return;

                result.fold((l) {
                  var snackBar = SnackBar(content: Text(l),behavior: SnackBarBehavior.floating,);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }, (r) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                    return RootPage();
                  },), (route) {
                    return false;
                  },);
                },);
              }, title: "Sign In"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signinText() {
    return Text(
      "Sign In",
      style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: InputDecoration(
        labelText: "Enter Email",
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _password,
      decoration: InputDecoration(labelText: "Password"));
  }

  Widget _signInFooterText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Not A Member? ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          TextButton(
            onPressed: () {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                return  SignupPage();
                              },));
            },
            child: Text(
              "Register Now",
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
