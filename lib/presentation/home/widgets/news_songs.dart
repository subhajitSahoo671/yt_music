// import 'dart:developer';

//import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/core/configs/theme/app_colors.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';
//import 'package:yt_music/common/helpers/is_dark_mode.dart';
// import 'package:yt_music/core/configs/constants/app_urls.dart';
// import 'package:yt_music/domain/entities/song/song.dart';
import 'package:yt_music/presentation/home/bloc/news_songs_cubit.dart';
import 'package:yt_music/presentation/home/bloc/news_songs_state.dart';
import 'package:yt_music/presentation/song_player/pages/song_player.dart';

class NewsSongs extends StatelessWidget {
  final MyAudioHandler audioHandler;
  final List<MediaItem> songs;
   
  const NewsSongs({super.key, required this.audioHandler , this.songs = const []});

  @override
  Widget build(BuildContext context) {
    print("Pinku : $songs");
    return Column(
      mainAxisSize: .min,
      children: [
         Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Bollywood Hits",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                // //Spacer(),
                // TextButton(
                //   onPressed: () {},
                //   child: Text("${songs.length} Songs", style: TextStyle(fontSize: 13)),
                // ),
              ],
            ),
              SizedBox(height: 10),
        SizedBox(
          height: 255,
          child: _songs()),
      ],
    );
  }

  Widget _songs() {
    //log(songs[0].title);
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: songs.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(width: 15);
      },
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return StreamBuilder<MediaItem?>(stream: audioHandler.mediaItem,
         builder: (context, snapshot) {
          
          if (snapshot.data != null) {
            // log(  "hy${snapshot.data!.artUri}");
            // var newIndex = songs.length - index - 1;
          return  GestureDetector(
                 onTap: () async{

              //     await audioHandler.initSongsIfNeeded(songs: songs);
              // if (snapshot.data!.id != songs[index].id) {
              //     audioHandler.skipToQueueItem(index);
              //   }

             await  audioHandler.initSongsIfNeeded(songs: songs).then((_) {
                if (snapshot.data!.id != songs[index].id) {
                  audioHandler.skipToQueueItem(index);
                }
              });
                
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SongPlayerPage(item: songs[index],audioHandler: audioHandler,);
                },
              ),
            );
          },
          child: SizedBox(
            // color: snapshot.data!.id == songs[newIndex].id ? AppColors.greyText.withValues(alpha: 50) : Colors.transparent,
            width: 135,
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(songs[index].artUri.toString()),
                    ),
                  ),
                  child: snapshot.data!.id == songs[index].id 
                  ? Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 33,
                      width: 33,
                      transform: Matrix4.translationValues(-10, 10, 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.greyText
                            .withBlue(50)
                            .withValues(alpha: 200),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                         if (audioHandler.playbackState.value.playing) {
                                  audioHandler.pause();
                                } else {
                                  audioHandler.play();
                                }
                      }, icon: Icon( audioHandler.playbackState.value.playing
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                                   size: 23)),
                    ),
                  )
                  : null,
                ),
                SizedBox(height: 10),
                Text(
                  songs[index].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: snapshot.data!.id == songs[index].id ? Colors.purpleAccent.shade700.withGreen(
                                          110,
                                        ) : null,
                    // color: Colors.white
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  songs[index].artist!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    // color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        );
          }
          return SizedBox.shrink();
        },);
      },
    );
  }
}
