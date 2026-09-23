import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:yt_music/common/widgets/hero_widgets/app_logo_widget.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:yt_music/common/helpers/is_dark_mode.dart';
// import 'package:yt_music/core/configs/theme/app_colors.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';
import 'package:yt_music/domain/entities/song/song_playlist.dart';
// import 'package:yt_music/domain/entities/song/song.dart';
// import 'package:yt_music/presentation/home/bloc/play_list_cubit.dart';
// import 'package:yt_music/presentation/home/bloc/play_list_state.dart';
import 'package:yt_music/presentation/home/widgets/playlist_widget.dart';

// import 'package:yt_music/presentation/song_player/pages/song_player.dart';

class PlayList extends StatelessWidget {
  final MyAudioHandler audioHandler;
  final List<MediaItem> songs;
  final SongPlaylistEntity? playlistData;
  final String playlistTitle;
  final bool? isBottomSheet;

  const PlayList({
    super.key,
    required this.audioHandler,
    required this.songs,
    required this.playlistTitle,
    this.playlistData,
    this.isBottomSheet = false
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isBottomSheet == false ? AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          playlistTitle,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ) : null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          mainAxisSize: MainAxisSize.min,
          children: [
           playlistData == null 
           ?  Column(
             children: [
               if(isBottomSheet == true) Container(
                  //  margin: const EdgeInsets.only(top: 0, bottom: 8),
                  width: 35,
                  height: 4,
                   decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
              ),
              ),
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: .center,
                  children: [
                    // Text(
                    //   "PlayList",
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 18,
                    //   ),
                    // ),
                    AppLogoWidget(width: 90, height: 40),
                    //Spacer(),
                   Text(
                        "${songs.length} Songs",
                        style: TextStyle(fontSize: 13),
                      ),
                  ],
                ),
             ],
           )
            : Column(
              crossAxisAlignment: .start,
                children: [
                  //pic
                 Align(
                  alignment: .center,
                  child:  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: Container(
                      width: MediaQuery.widthOf(context)/1.8,
                      height: MediaQuery.widthOf(context)/1.8,
                      decoration: BoxDecoration(
                        borderRadius: .circular(10),
                        color: Colors.blueGrey.withAlpha(150)
                      ),
                      child: Image.network(playlistData!.imageURL,fit: .cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network("https://img.magnific.com/premium-psd/music-note-3d-icon-with-musical-symbol-made-with-translucent-png-trendy-neon-color-shape_1020495-522146.jpg?semt=ais_hybrid&w=740&q=80",fit: BoxFit.cover);
                      },
                      ),
                    ),
                  ),
                 ),
      
                  SizedBox(height: 20,),
      
                 Column(
                  crossAxisAlignment: .start,
                  children: [
                     //description
                   Padding(
                     padding: const EdgeInsets.only(left: 8),
                     child: Text(
                      maxLines: 3,
                      overflow: .fade,
                      "${playlistData!.playlistDescription} Songs",
                      style: TextStyle(fontSize: 13),
                                       ),
                   ),
                  SizedBox(height: 10,),
      
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                       //logo
                    AppLogoWidget(width: 85, height: 30),
                    // SizedBox(height: 5,),
                  //album ,count
                  Text(
                    "${playlistData!.isAlbum ? "Album":"Playlist"} • ${songs.length} Songs",
                    style: TextStyle(fontSize: 13,fontWeight: .w500),
                  ),
                    ],
                  )
                  ],
                 )
                ],
            ),
            SizedBox(height: 20),
            Flexible(child: _songs(songs)),
          ],
        ),
      ),
    );
  }

  Widget _songs(List<MediaItem> songs) {
    //log(songs.toString());
    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: songs.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 17);
      },
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        // print("pinkuuu=$songs");
        return PlaylistWidget(
          songEntity: songs[index],
          index: index,
          audioHandler: audioHandler,
          isBottomSheet : isBottomSheet,
          audioHandlerInitSongs: () async {
            if (songs.isEmpty) {
              return;
            }
            await audioHandler.initSongsIfNeeded(songs: songs);
            // audioHandler.skipToQueueItem(index);
          },
        );
      },
    );
  }
}


