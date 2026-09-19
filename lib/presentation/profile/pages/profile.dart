import 'package:audio_service/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light_dark_theme_toggle/light_dark_theme_toggle.dart';
import 'package:yt_music/common/helpers/is_dark_mode.dart';
import 'package:yt_music/common/widgets/button/basic_app_bar.dart';
import 'package:yt_music/core/configs/theme/app_colors.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';
import 'package:yt_music/presentation/auth/pages/signin.dart';
import 'package:yt_music/presentation/auth/pages/signup_or_signin.dart';
import 'package:yt_music/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:yt_music/presentation/home/widgets/playlist_widget.dart';
import 'package:yt_music/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:yt_music/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:yt_music/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:yt_music/presentation/profile/bloc/profile_info_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.audioHandler});

  final MyAudioHandler audioHandler;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future<void> signedOut(BuildContext context) async{
   try {
    await FirebaseAuth.instance.signOut(); 
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignupOrSignin(hideBackBotton: true,),),
     (route) => false,
    );
    print("User successfully signed out");
  } catch (e) {
    print("Error signing out: $e");
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Profile'),
        action: PopupMenuButton<String>(
          elevation: 3,
          borderRadius: BorderRadius.circular(30),
          onSelected: (String value) {
            // print('Selected: $value');
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(value: "Mode", child: _chooseMode(context)),
              PopupMenuDivider(indent: 8,endIndent: 8,),
              PopupMenuItem<String>(value: "Logout", child: Center(child: Icon(Icons.logout,size: 24,)),onTap: () {
                signedOut(context);
              },),
            ];
          },
        ),
      ),
      body: Container(
        // height: MediaQuery.sizeOf(context).height,
        color: AppColors.primary.withValues(alpha: 0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _profileInfo(context),
            SizedBox(height: 30),
            Expanded(child: _favoriteSongs(widget.audioHandler, context)),
          ],
        ),
      ),
    );
  }

  Widget _chooseMode(BuildContext context){
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return Row(
          mainAxisAlignment: .center,
          children: [
            Center(
              child: LightDarkThemeToggle(
                padding: .zero,
                value: mode != ThemeMode.dark,
                onChanged: (bool value) {
                  context.read<ThemeCubit>().updateTheme(
                    value ? ThemeMode.light : ThemeMode.dark,
                  );
                },
                size: 24.0,
                themeIconType: ThemeIconType.expand,
                color: Colors.orange,
                tooltip: 'Toggle Theme',
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Container(
        height: MediaQuery.sizeOf(context).height / 4.2,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
            if (state is ProfileInfoLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is ProfileInfoLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 47,
                    backgroundImage: NetworkImage(state.userEntity.imageURL!),
                  ),
                  SizedBox(height: 15),
                  Text(
                    state.userEntity.email!,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    state.userEntity.fullName!,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                ],
              );
            }

            if (state is ProfileInfoFailure) {
              return Center(child: Text('Please try again later'));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _favoriteSongs(MyAudioHandler audioHandler, BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteSongsCubit()..getFavoriteSongs(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "FAVORITE SONGS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.lightBackground,
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
                builder: (context, state) {
                  if (state is FavoriteSongsLoading) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (state is FavoriteSongsLoaded) {
                    return ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemCount: state.favoriteSongs.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: 17);
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return PlaylistWidget(
                                function: () {
                                  context
                                      .read<FavoriteSongsCubit>()
                                      .removeSong(index);
                                },
                                songEntity: state.favoriteSongs[index],
                                index: index,
                                audioHandler: audioHandler,
                                isFavorite: true,
                                activeColor: Colors.cyanAccent,
                                textColor: AppColors.lightBackground,
                                audioHandlerInitSongs: () async {
            if (state.favoriteSongs.isEmpty) {
              return;
            }
            await audioHandler.initSongsIfNeeded(songs: state.favoriteSongs);
          },
                              );
                            },
                          );
                  }

                  if (state is FavoriteSongsFailure) {
                    return Text("Please try again");
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
