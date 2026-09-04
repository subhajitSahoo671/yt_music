import 'package:flutter/material.dart';
import 'package:yt_music/core/configs/assets/app_images.dart';
// import 'package:yt_music/core/configs/assets/app_vectors.dart';
// import 'package:flutter_svg/svg.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key,required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app-logo',
      child: Image.asset(
            AppImages.appLogo,
            width: width,
            height: height,
            fit: BoxFit.contain,
          ),
    );
  }
}