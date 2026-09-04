import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/common/helpers/is_dark_mode.dart';
import 'package:yt_music/common/widgets/button/basic_app_bar.dart';
import 'package:yt_music/common/widgets/hero_widgets/app_logo_widget.dart';
import 'package:yt_music/core/configs/assets/app_images.dart';
//import 'package:yt_music/core/configs/assets/app_vectors.dart';
import 'package:yt_music/core/configs/theme/app_colors.dart';
// import 'package:yt_music/presentation/home/bloc/play_list_cubit.dart';
// import 'package:yt_music/presentation/home/bloc/play_list_state.dart';
import 'package:yt_music/presentation/home/widgets/news_songs.dart';
import 'package:yt_music/presentation/home/widgets/play_list.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:audio_service/audio_service.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';
import 'package:yt_music/presentation/profile/pages/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.audioHandler, this.songs = const []});
  final MyAudioHandler audioHandler;
  final List<MediaItem> songs;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    @override
  void initState() {
    super.initState();
    _audioHandlerInitSongs();
  }

  Future<void> _audioHandlerInitSongs() async {
    await widget.audioHandler.initSongs(songs: widget.songs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: AppLogoWidget(width: 120, height: 45),
        action: IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ProfilePage(audioHandler: widget.audioHandler);
          },));
        }, icon: FaIcon(FontAwesomeIcons.solidCircleUser, color: AppColors.primary, size: 26,)),
        hideBackBotton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _homeTopArtistCard(context),
              SizedBox(height: 10),
              DefaultTabController(
                length: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _tabs(context),
                    SizedBox(
                      height: 280,
                      child: TabBarView(
                        children: [
                          NewsSongs(audioHandler: widget.audioHandler, songs: widget.songs),
                          Container(),
                          Container(),
                          Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              PlayList(audioHandler: widget.audioHandler, songs: widget.songs),
            ],//
          ),//
        ),//
      ),//
    );
  }

  Widget _homeTopArtistCard(context) {
    return Center(
      child: SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                transform: Matrix4.translationValues(0, -15, 0),
                width: MediaQuery.of(context).size.width,
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 170,
                              child: Text(
                                "Now Album Happier Than Ever",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Smruti Eillish",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(flex: 4, child: Container()),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Transform(
                transform: Matrix4.translationValues(0, -15, 0),
                child: Image.asset(
                  AppImages.homeTopArtist,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs(BuildContext context) {
    return TabBar(
      isScrollable: true,
      dividerColor: Colors.transparent,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      labelPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      tabAlignment: TabAlignment.center,
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [Text("News"), Text("Videos"), Text("Artist"), Text("Podcasts")],
    );
  }

}
