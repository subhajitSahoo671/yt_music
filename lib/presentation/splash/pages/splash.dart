import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:yt_music/common/helpers/is_dark_mode.dart';
import 'package:yt_music/core/configs/assets/app_images.dart';
import 'package:yt_music/presentation/auth/auth_wrapper.dart';
//import 'package:yt_music/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:yt_music/presentation/intro/pages/get_started.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: 
        // BlocBuilder<ThemeCubit,ThemeMode>(
        //   builder: (context, mode) => 
          Image.asset(
           //mode == ThemeMode.light ? AppImages.logoLight : AppImages.logoDark,
          AppImages.splashLogo,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
       // ),
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const AuthWrapper()),
    );
  }
}
