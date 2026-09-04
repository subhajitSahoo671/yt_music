
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:yt_music/common/helpers/is_dark_mode.dart';
// import 'package:yt_music/core/configs/theme/app_colors.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';
// import 'package:yt_music/domain/entities/song/song.dart';
// import 'package:yt_music/presentation/home/bloc/play_list_cubit.dart';
// import 'package:yt_music/presentation/home/bloc/play_list_state.dart';
import 'package:yt_music/presentation/home/widgets/playlist_widget.dart';
// import 'package:yt_music/presentation/song_player/pages/song_player.dart';

class PlayList extends StatelessWidget {
  final MyAudioHandler audioHandler;
  final List<MediaItem> songs;

  const PlayList({super.key, required this.audioHandler, this.songs = const []});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "PlayList",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            //Spacer(),
            TextButton(
              onPressed: () {},
              child: Text("See More", style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        SizedBox(height: 15,),
        Flexible(
          child: _songs(songs),
        ),
      ],
    );
  }

  Widget _songs(List<MediaItem> songs) {
   
    //log(songs.toString());
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: songs.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 17);
      },
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return PlaylistWidget(songEntity: songs[index], index: index, audioHandler: audioHandler);
      },
    );
  }
}