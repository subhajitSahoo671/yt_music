import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
// import 'package:flutter/widgets.dart';
// import 'package:yt_music/core/configs/theme/app_colors.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';
import 'package:yt_music/domain/entities/song/song_playlist.dart';
import 'package:yt_music/presentation/home/widgets/play_list.dart';
// import 'package:yt_music/presentation/song_player/pages/song_player.dart';

class RowPlaylist extends StatelessWidget {
  const RowPlaylist({super.key,  required this.audioHandler , required this.playlists, required this.title, this.loading});
    final MyAudioHandler audioHandler;
  final List<SongPlaylistEntity> playlists;
  final String title;
  final bool? loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      
      mainAxisSize: .min,
      children: [
         Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
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
    return Skeletonizer(
      enabled: loading ?? false,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 15);
        },
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return  GestureDetector(
                   onTap: () {
                   
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PlayList(audioHandler: audioHandler,songs: playlists[index].tracks.toSet().toList(),playlistData: playlists[index],playlistTitle:  playlists[index].isAlbum ? "Album" : "Playlist",);
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
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(5),
                    child: Container(
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                       color: Colors.cyan
                                        .withValues(alpha: 150).withAlpha(150),
                      ),
                      child: Image.network(playlists[index].imageURL.toString(),fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network("https://img.magnific.com/premium-psd/music-note-3d-icon-with-musical-symbol-made-with-translucent-png-trendy-neon-color-shape_1020495-522146.jpg?semt=ais_hybrid&w=740&q=80",fit: BoxFit.cover);
                      },
                      )
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                     playlists[index].isAlbum ? "Album" : "Playlist",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      // color: Colors.white
                    ),
                  ),
                  SizedBox(height: 4),
                   Text(
                    playlists[index].playlistTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                 
                ],
              ),
            ),
          );
           
        },
      ),
    );
  }

}