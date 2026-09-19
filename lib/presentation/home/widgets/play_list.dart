import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:yt_music/common/widgets/hero_widgets/app_logo_widget.dart';
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

  const PlayList({
    super.key,
    required this.audioHandler,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "PlayList",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "${songs.length} Songs",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Flexible(child: _songs(songs)),
          ],
        ),
      ),
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
        // print("pinkuuu=$songs");
        return PlaylistWidget(
          songEntity: songs[index],
          index: index,
          audioHandler: audioHandler,
          audioHandlerInitSongs: () async {
            if (songs.isEmpty) {
              return;
            }
            await audioHandler.initSongsIfNeeded(songs: songs);
            audioHandler.skipToQueueItem(index);
          },
        );
      },
    );
  }
}


