import 'package:flutter/material.dart';
import 'package:yt_music/common/widgets/button/basic_app_bar.dart';
import 'package:yt_music/common/widgets/button/basic_app_button.dart';
import 'package:yt_music/common/widgets/hero_widgets/app_logo_widget.dart';
import 'package:yt_music/core/configs/assets/app_images.dart';
import 'package:yt_music/core/configs/assets/app_vectors.dart';
import 'package:yt_music/core/configs/theme/app_colors.dart';
import 'package:yt_music/presentation/auth/pages/signin.dart';
import 'package:yt_music/presentation/auth/pages/signup.dart';
import 'package:flutter_svg/svg.dart';

class SignupOrSignin extends StatelessWidget {
  const SignupOrSignin({super.key, this.hideBackBotton});
  final bool? hideBackBotton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Stack(
        children: [
          BasicAppBar(hideBackBotton: hideBackBotton ?? false,),
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(AppVectors.topPattern),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(AppVectors.bottomPattern),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(AppImages.authBG),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40
            ),
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppLogoWidget(width: 240, height: 80),
                    SizedBox(height: 60),
                    Text(
                      "Enjoy Listening To Music",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryTextTheme.bodyMedium?.color,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Spotify is a proprietary Swedish audio streaming and media services provider ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: BasicAppButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return  SignupPage();
                              },));
                            },
                            title: "Register",
                            height: 67,
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return  SigninPage();
                              },));
                            },
                            child: Text("Sign in",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 160,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
