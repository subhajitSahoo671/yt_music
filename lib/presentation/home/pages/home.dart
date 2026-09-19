import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/common/helpers/is_dark_mode.dart';
import 'package:yt_music/common/widgets/button/basic_app_bar.dart';
import 'package:yt_music/common/widgets/hero_widgets/app_logo_widget.dart';
import 'package:yt_music/core/configs/assets/app_images.dart';
//import 'package:yt_music/core/configs/assets/app_vectors.dart';
import 'package:yt_music/core/configs/theme/app_colors.dart';
import 'package:yt_music/presentation/home/bloc/news_songs_cubit.dart';
import 'package:yt_music/presentation/home/bloc/news_songs_state.dart';
import 'package:yt_music/presentation/home/bloc/play_list_cubit.dart';
import 'package:yt_music/presentation/home/bloc/play_list_state.dart';
// import 'package:yt_music/presentation/home/bloc/play_list_cubit.dart';
// import 'package:yt_music/presentation/home/bloc/play_list_state.dart';
import 'package:yt_music/presentation/home/widgets/news_songs.dart';
import 'package:yt_music/presentation/home/widgets/play_list.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:audio_service/audio_service.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';
import 'package:yt_music/presentation/home/widgets/row_playlist.dart';
import 'package:yt_music/presentation/profile/pages/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yt_music/presentation/song_player/pages/song_player.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.audioHandler,
    this.songs = const [],
  });
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

  var textColor = AppColors.lightBackground;
  bool loading = true;

  Future<void> _audioHandlerInitSongs() async {
    // print("kffsiii ${widget.songs}");
    if (widget.songs.isEmpty) {
      return;
    }

    await widget.audioHandler.initSongsIfNeeded(songs: widget.songs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: AppLogoWidget(width: 120, height: 45),
        action: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProfilePage(audioHandler: widget.audioHandler);
                },
              ),
            );
          },
          icon: FaIcon(
            FontAwesomeIcons.solidCircleUser,
            color: AppColors.primary,
            size: 26,
          ),
        ),
        hideBackBotton: true,
      ),
      body: SizedBox(
        height: MediaQuery.heightOf(context),
        width: MediaQuery.widthOf(context),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _homeTopArtistCard(context),
                    SizedBox(height: 10),
                    // DefaultTabController(
                    //   length: 4,
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       _tabs(context),
                    //       SizedBox(
                    //         height: 280,
                    //         child: TabBarView(
                    //           children: [
                    //             // NewsSongs(audioHandler: widget.audioHandler, songs: widget.songs),
                    //             Container(),
                    //             Container(),
                    //             Container(),
                    //             Container(),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    NewsSongs(
                      audioHandler: widget.audioHandler,
                      songs: widget.songs,
                    ),
                    SizedBox(height: 24),
                    _topTracks(),
                    SizedBox(height: 10,),
                    // PlayList(audioHandler: widget.audioHandler, songs: widget.songs),
                
                // TrendingOfTheMonthPlaylist
                    BlocProvider(
                      create: (context) =>
                          PlayListCubit()..getTrendingOfTheMonthPlaylist(),
                      child: BlocBuilder<PlayListCubit, PlayListState>(
                        builder: (context, state) {
                          if (state is PlayListLoading) {
                            return _loadingSkeleton();
                          }
                          if (state is ListOfPlayListLoaded) {
                             
                            return RowPlaylist(
                                    title: "Trendings Of Month",
                                    audioHandler: widget.audioHandler,
                                    playlists: state.playlist,
                                  );
                          }
                          return Container();
                        }, //
                      ), //
                    ),

                    // PopularAlbumOfTheWeek
                    BlocProvider(
                      create: (context) =>
                          PlayListCubit()..getPopularAlbumOfTheWeek(),
                      child: BlocBuilder<PlayListCubit, PlayListState>(
                        builder: (context, state) {
                          if (state is PlayListLoading) {
                            return _loadingSkeleton();
                          }
                          if (state is ListOfPlayListLoaded) {
                            return  RowPlaylist(
                                    title: "Popular Albums Of the Weak",
                                    audioHandler: widget.audioHandler,
                                    playlists: state.playlist,
                                  );
                          }
                          return Container();
                        }, //
                      ), //
                    ),
                    SizedBox(height: 100,)
                  ], //
                ), //
              ), //
            ),
             Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 3,
                    borderRadius: .circular(10),
                     color: Colors.blueGrey,
                     shadowColor: AppColors.gradient_1.withValues(alpha: 0.8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: .circular(10)
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //         colors: [AppColors.gradient_1.withValues(alpha: 0.8), AppColors.gradient_2.withValues(alpha: 0.8)],
                            //         begin: AlignmentGeometry.topLeft,
                            //         end: AlignmentGeometry.bottomRight,
                            //       ),
                          borderRadius: .circular(10)
                        ),
                        child: StreamBuilder<MediaItem?>(
                          stream: widget.audioHandler.mediaItem,
                          builder: (context, asyncSnapshot) {
                            if (asyncSnapshot.data != null) {
                              return InkWell(
                                overlayColor: .all(Colors.transparent),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return SongPlayerPage(
                                          item: asyncSnapshot.data!,
                                          audioHandler: widget.audioHandler,
                                        );
                                      },
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(0.0, 1.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;

                                        var tween = Tween(
                                          begin: begin,
                                          end: end,
                                        ).chain(CurveTween(curve: curve));
                                        var offsetAnimation = animation.drive(
                                          tween,
                                        );

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    // pic
                                    ClipRRect(
                                       borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Image.network(
                                          asyncSnapshot.data!.artUri.toString(),
                                          fit: .cover,
                                           errorBuilder: (context, error, stackTrace) {
                      return Image.network("https://img.magnific.com/premium-psd/music-note-3d-icon-with-musical-symbol-made-with-translucent-png-trendy-neon-color-shape_1020495-522146.jpg?semt=ais_hybrid&w=740&q=80",fit: BoxFit.cover);
                    },
                                        ),
                                      ),
                                    ),
                              
                                    //title
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          Text(
                                            asyncSnapshot.data!.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w600,
                              
                                              // color: Colors.white
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            asyncSnapshot.data!.artist!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w400,
                                              // color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
    
                                    // play button
                                    Expanded(
                                      flex: 3,
                                      child: StreamBuilder<PlaybackState>(
                                        stream:
                                            widget.audioHandler.playbackState.stream,
                                        builder: (context, snapshot) {
                                          bool playing =
                                              snapshot.data?.playing ?? false;
                                          // log("Playing state: $snapshot.data");
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                 onTap: () {
                                                  widget.audioHandler
                                                      .skipToPrevious();
                                                },
                                                child: Icon(
                                                  size: 25,
                                                  color: Colors.white,
                                                  Icons.skip_previous_rounded,
                                                ),
                                              ),
                                              // SizedBox(width: 10),
                              
                                              GestureDetector(
                                                 onTap: () {
                                                  if (playing) {
                                                    widget.audioHandler.pause();
                                                  } else {
                                                    widget.audioHandler.play();
                                                  }
                                                },
                                                child: Icon(
                                                  size: 30,
                                                  color: Colors.white,
                                                  playing
                                                      ? Icons.pause_rounded
                                                      : Icons.play_arrow_rounded,
                                                ),
                                               
                                              ),
                                              // SizedBox(width: 10),
                              
                                              GestureDetector(
                                                  onTap: () {
                                                  widget.audioHandler.skipToNext();
                                                },
                                                child: Icon(
                                                  size: 25,
                                                  color: Colors.white,
                                                  Icons.skip_next_rounded,
                                                ),
                                              
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
             
          ],
        ),
      ), //
    );
  }

  Widget _topTracks() {
    return GridView.extent(
      maxCrossAxisExtent: 200,
      mainAxisExtent: 60,
      mainAxisSpacing: 20,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        BlocProvider(
          create: (context) => NewsSongsCubit()..getNewsSongs(),
          child: BlocBuilder<NewsSongsCubit, NewsSongsState>(
            builder: (context, state) {
              if (state is NewsSongsLoading) {
                return _loadingSkeleton(compact: true);
              }
              if (state is NewsSongsLoaded) {
                return  _listTracks(
                        state.songs,
                        "Latest Songs",
                      );
              }

              return Text('Error loading songs');
            },
          ),
        ),
        BlocProvider(
          create: (context) => PlayListCubit()..getPlayList(),
          child: BlocBuilder<PlayListCubit, PlayListState>(
            builder: (context, state) {
              if (state is PlayListLoading) {
                return _loadingSkeleton(compact: true);
              }
              if (state is PlayListLoaded) {
                return  _listTracks(
                        state.songs,
                        "Trending Songs",
                      );
              }

              return Text('Error loading songs');
            },
          ),
        ),
        // _listTracks(),
        // _listTracks(),
      ],
    );
  }

  Widget _listTracks(List<MediaItem> songs, String listTitle) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlayList(audioHandler: widget.audioHandler, songs: songs),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey.withAlpha(150),
          ),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.cyan.withValues(alpha: 100).withAlpha(150),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(songs.first.artUri.toString()),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      listTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.lightBackground,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Playlist",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        // color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingSkeleton({bool compact = false}) {
    return Skeletonizer(
      child: compact
        ? ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey.withAlpha(150),
              ),
              child: Row(
                children: [
                  Bone.square(size: 60),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone.text(width: 90),
                        SizedBox(height: 6),
                        Bone.text(width: 55),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        )
        : SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, index) => SizedBox(width: 15),
              itemBuilder: (_, index) => SizedBox(
                width: 135,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Bone.square(size: 170)),
                    SizedBox(height: 10),
                    Bone.text(width: 110),
                    SizedBox(height: 5),
                    Bone.text(width: 80),
                  ],
                ),
              ),
            ),
          )
      );
  }

  Widget _homeTopArtistCard(BuildContext context) {
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
                child: Image.asset(AppImages.homeTopArtist, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _tabs(BuildContext context) {
  //   return TabBar(
  //     isScrollable: true,
  //     dividerColor: Colors.transparent,
  //     labelColor: context.isDarkMode ? Colors.white : Colors.black,
  //     labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
  //     labelPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
  //     tabAlignment: TabAlignment.center,
  //     indicatorSize: TabBarIndicatorSize.tab,
  //     tabs: [Text("News"), Text("Videos"), Text("Artist"), Text("Podcasts")],
  //   );
  // }
}
