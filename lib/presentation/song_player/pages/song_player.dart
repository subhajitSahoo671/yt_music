

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yt_music/common/widgets/favorite_button/favorite_button.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/core/configs/theme/app_colors.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yt_music/presentation/home/widgets/play_list.dart';

class SongPlayerPage extends StatelessWidget {
  final MediaItem item;
  
  // final int index;
  
  final MyAudioHandler audioHandler;
  
  const SongPlayerPage({super.key, required this.item, required this.audioHandler});

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Now Playing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: FaIcon(FontAwesomeIcons.barsStaggered, size: 20),
        //   ),
        // ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16),
        ),
        backgroundColor: AppColors.primary.withValues(alpha: 0.8),
        elevation: 0,
      ),
      body: _PlayerContent(item: item, audioHandler: audioHandler),
    );
  }
}

class _PlayerContent extends StatelessWidget {
  final MediaItem item;
  final MyAudioHandler audioHandler;

  const _PlayerContent({required this.item, required this.audioHandler});

  Future<void> _shareSong(BuildContext context, MediaItem item) async {
    final songUrl = item.extras?['songURL'] as String? ?? item.id;
    final uri = Uri.tryParse(songUrl);

    if (uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This song has no shareable link.')),
      );
      return;
    }

    final text =
        'Check out "${item.title}" on my ZYNC music app! Listen here: $songUrl';
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        title: item.title,
        // uri: uri,
      ),
    );
  }

  void _showPlaylistBottomSheet(BuildContext context){
     showModalBottomSheet(context: context,
     backgroundColor: AppColors.primary,
      barrierColor: Colors.black.withAlpha(200),
      barrierLabel: "Playlist",
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      anchorPoint: Offset(100, 100),
      useSafeArea: true,
      enableDrag: true,
      // showDragHandle: true,
      elevation: 20,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.heightOf(context) * 0.70,
        maxWidth: 400,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return PlayList(audioHandler: audioHandler, songs: audioHandler.queue.value, playlistTitle: "playlistTitle",isBottomSheet : true,);
      },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: AppColors.primary.withValues(alpha: 0.8),
          child: StreamBuilder<MediaItem?>(
            stream: audioHandler.mediaItem,
            builder: (context, itemSnapshot) {

              if (itemSnapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return Stack(
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xff6C6AF0).withAlpha( 100)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                      child: Column(
                        children: [
                          //SizedBox(height: 40),
                          _songCover(context, itemSnapshot.data!),
                          _loopingShuffling(context),
                          SizedBox(height: 15),
                          _songDetails(itemSnapshot.data!),
                          SizedBox(height: 40),
                          songTools(context, itemSnapshot.data!),
                          SizedBox(height: 40),
                          _songSlider(context, itemSnapshot.data!), 
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _songPlayer(context),
                  ),
                ],
              );
            }
          ),
        );
  }

  Widget _songCover(BuildContext context, MediaItem item) {
    return Container(
      height: MediaQuery.of(context).size.width / 1.4,
      width: MediaQuery.of(context).size.width / 1.4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(item.artUri.toString()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _loopingShuffling(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              
              audioHandler.playbackState.value.repeatMode == AudioServiceRepeatMode.all ?
                audioHandler.setRepeatMode(AudioServiceRepeatMode.one) :
              audioHandler.playbackState.value.repeatMode == AudioServiceRepeatMode.one ?
                audioHandler.setRepeatMode(AudioServiceRepeatMode.none) :
                audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
                //log( "Repeat mode changed: ${audioHandler.playbackState.value.repeatMode}" );
            },
            icon: Icon(
              audioHandler.playbackState.value.repeatMode == AudioServiceRepeatMode.all ? Icons.repeat_rounded :
              audioHandler.playbackState.value.repeatMode == AudioServiceRepeatMode.one ? Icons.repeat_one_rounded :
              Icons.repeat_rounded,
              color: audioHandler.playbackState.value.repeatMode != AudioServiceRepeatMode.none ? Colors.pink.shade900 : Colors.white70, 
              size: 28,
            ),
          ),
          SizedBox(width: 20),
          IconButton(
            onPressed: () {
              audioHandler.playbackState.value.shuffleMode == AudioServiceShuffleMode.all ?
                audioHandler.setShuffleMode(AudioServiceShuffleMode.none) :
              audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
            },
            icon: audioHandler.playbackState.value.shuffleMode == AudioServiceShuffleMode.all ? Icon(
              Icons.shuffle_rounded, color: Colors.pink.shade900, size: 28) :
               Icon(
              Icons.shuffle_rounded, color: Colors.white70, size: 28),
          ),
        ],
      ),
    );
  }

   

  Widget _songDetails( MediaItem item) {
    return Column(
      children: [
        Text(
          item.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          item.artist ?? 'Unknown Artist',
          style: TextStyle(
            color: Colors.pinkAccent.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget songTools(BuildContext context,MediaItem itemSnapshot) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FavoriteButton(songEntity: itemSnapshot, color: Colors.pink.shade800, size: 30,),
          VerticalDivider(
            width: 3,
            color: Colors.pinkAccent.shade700,
            thickness: 2,
            indent: 10,
            radius: BorderRadius.circular(30),
          ),
          IconButton(
            onPressed: () {
                _showPlaylistBottomSheet(context);
            },
            icon: Icon(
              Icons.queue_music_rounded,
              size: 32,
              color: Colors.white70,
            ),
          ),
          VerticalDivider(
            width: 3,
            color: Colors.pinkAccent.shade700,
            thickness: 2,
            indent: 10,
            radius: BorderRadius.circular(30),
          ),
          IconButton(
            onPressed: () {
              // print("wwe ${itemSnapshot.extras!["songURL"]}");
              _shareSong(
                context,
                itemSnapshot
              );
            },
            icon: FaIcon(
              FontAwesomeIcons.shareNodes,
              color: Colors.pink.shade800,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _songSlider(BuildContext context, MediaItem itemSnapshot) {

        return StreamBuilder<Duration>(
          stream: AudioService.position,
          builder: (context, positionSnap) {
            final position = positionSnap.data ?? Duration.zero;     
          // log(positionSnap.data.toString());
           
            final total = itemSnapshot.duration ?? Duration.zero;
            // print("jjjjj${itemSnapshot.duration!.inMinutes}");
            // Avoid division by zero when duration is zero.
            final maxSeconds = total.inSeconds > 0 ? total.inSeconds.toDouble() : 1.0;
            final value = position.inSeconds.toDouble().clamp(0.0, maxSeconds);

            return Column(
              children: [
                Slider(
                  activeColor: Color(0xff5A8FF0).withValues(alpha: 100),
                  value: value,
                  min: 0.0,
                  max: maxSeconds,
                 // divisions: value.toInt() > 0 ? value.toInt() : null,
                  onChanged: (v) {
                    audioHandler.seek(Duration(seconds: v.toInt()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDuration(position)),
                      Text(formatDuration(total)),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours.remainder(60);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
  }

  Widget _songPlayer(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: audioHandler.playbackState.stream,
      builder: (context, snapshot) {
        bool playing = snapshot.data?.playing ?? false;
       // log("Playing state: $snapshot.data");
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              colors: [AppColors.gradient_1.withValues(alpha: 0.8), AppColors.gradient_2.withValues(alpha: 0.8)],
              begin: AlignmentGeometry.topLeft,
              end: AlignmentGeometry.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  audioHandler.skipToPrevious();
                },
                icon: Icon(
                  size: 35,
                  color: Colors.white,
                  Icons.skip_previous_rounded,
                ),
              ),
              SizedBox(width: 30),
              VerticalDivider(
                width: 3,
                color: Colors.white,
                indent: 30,
                endIndent: 30,
                thickness: 1,
                radius: BorderRadius.circular(30),
              ),
              SizedBox(width: 30),
              IconButton(
                onPressed: () {
                  if (playing) {
                    audioHandler.pause();
                  } else {
                    audioHandler.play();
                  }
                },
                icon: Icon(
                  size: 40,
                  color: Colors.white,
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
              ),
              SizedBox(width: 30),
              VerticalDivider(
                width: 3,
                color: Colors.white,
                indent: 30,
                endIndent: 30,
                thickness: 1,
                radius: BorderRadius.circular(30),
              ),
              SizedBox(width: 30),  
              IconButton(
                onPressed: () {
                  audioHandler.skipToNext();
                },
                icon:
                    Icon(size: 35, color: Colors.white, Icons.skip_next_rounded),
              ),
            ],
          ),
        );
      },
    );
  }
}