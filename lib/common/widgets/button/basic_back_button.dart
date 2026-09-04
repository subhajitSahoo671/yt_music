import 'package:flutter/material.dart';
import 'package:yt_music/core/configs/theme/app_colors.dart';

   IconButton basicBackButton(BuildContext context) {


  return IconButton(
        style: ButtonStyle(
          //iconSize: WidgetStateProperty.all(14),
          overlayColor: WidgetStateProperty.all(
            AppColors.primary.withAlpha(30),
          ),
        ),
        icon: CircleAvatar(
          backgroundColor: AppColors.greyText.withAlpha(30),
          radius: 20,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).primaryTextTheme.bodyMedium?.color,
            size: 14,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );
}