import 'package:flutter/material.dart';
import 'package:yt_music/core/configs/theme/app_colors.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  const BasicAppButton({
    required this.onPressed,
    required this.title,
    this.height ,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: AppColors.primaryGradient,
      ),
      child: ElevatedButton(onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 70),
      ),
       child: Text(title)),
    );
  }
}
