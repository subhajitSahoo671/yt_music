import 'package:flutter/material.dart';
import 'package:yt_music/common/widgets/button/basic_back_button.dart';
// import 'package:yt_music/core/configs/theme/app_colors.dart';
//import 'package:yt_music/presentation/auth/pages/signup_or_signin.dart';
//import 'package:yt_music/presentation/auth/pages/signup_or_signin.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BasicAppBar({super.key, this.title, this.hideBackBotton = false,  this.action,});

  final Widget? title;
  final bool hideBackBotton;
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      animateColor: false,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title ?? Text(""),
      leading: hideBackBotton ? null : basicBackButton(context),
      actions: action != null ? [action!] : [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
