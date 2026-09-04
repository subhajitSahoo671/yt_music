import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/common/helpers/is_dark_mode.dart';
import 'package:yt_music/core/configs/theme/app_colors.dart';
import 'package:yt_music/presentation/choose_mode/bloc/theme_cubit.dart';

class ModeWidgets extends StatelessWidget {
  const ModeWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                            },
                            child: ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   color: Color(0xff30393C).withValues(alpha: 0.2),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      context.isDarkMode ? Icons.nightlight_rounded : Icons.nightlight_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Dark Mode",
                            style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 75),
                       Column(
                         children: [
                           GestureDetector(
                              onTap: () {
                                context.read<ThemeCubit>().updateTheme(ThemeMode.light);

                              },
                             child: ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   color: Color(0xff30393C).withValues(alpha: 0.2),
                                  ),
                                  child: Center(
                                    child: Icon(
                                     context.isDarkMode ? Icons.light_mode_outlined : Icons.light_mode_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                                                       ),
                           ),
                          SizedBox(height: 15),
                          Text(
                            "Light Mode",
                            style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                         ],
                       ),
                    ],
                 );
  }
}