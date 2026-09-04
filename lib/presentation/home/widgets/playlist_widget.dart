// import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:yt_music/common/widgets/favorite_button/favorite_button.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';
// import 'package:yt_music/common/helpers/is_dark_mode.dart';
import 'package:yt_music/core/configs/theme/app_colors.dart';
import 'package:yt_music/presentation/song_player/pages/song_player.dart';
import 'package:lottie/lottie.dart';

class PlaylistWidget extends StatelessWidget {
  final MediaItem songEntity;

  final int index;

  final MyAudioHandler audioHandler;

  final bool isFavorite;
  final Function? function;
  final Color? activeColor;
  final Color? textColor;

  const PlaylistWidget({
    super.key,
    required this.songEntity,
    required this.index,
    required this.audioHandler,
    this.isFavorite = false,
    this.function,
    this.activeColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, itemSnapshot) {
        if (itemSnapshot.data != null) {
          // log(itemSnapshot.data.toString());
          return GestureDetector(
            onTap: () {
              if (itemSnapshot.data!.id != songEntity.id) {
                audioHandler.skipToQueueItem(index);
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,

                  builder: (context) {
                    return SongPlayerPage(
                      item: itemSnapshot.data!,
                      index: index,
                      audioHandler: audioHandler,
                    );
                  },
                ),
              );
            },
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppColors.greyText
                                .withBlue(50)
                                .withValues(alpha: 200),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(songEntity.artUri.toString()),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                songEntity.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: itemSnapshot.data!.id == songEntity.id
                                      ? activeColor ??
                                            Colors.purpleAccent.shade700
                                                .withGreen(110)
                                      : textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.white
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                songEntity.artist.toString(),
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
                  SizedBox(width: 30),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        itemSnapshot.data!.id == songEntity.id
                            ? audioHandler.playbackState.value.playing
                                  ? Lottie.asset(
                                      "assets/lotties/equalizer.json",
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                      animate: true,
                                      delegates: LottieDelegates(
                                        values: [
                                          ValueDelegate.colorFilter(
                                            const [
                                              '**',
                                            ], // Wildcard matches all layers
                                            value: const ColorFilter.mode(
                                              Colors.cyanAccent,
                                              BlendMode.srcATop,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Lottie.asset(
                                      "assets/lotties/equalizer.json",
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                      animate: false,
                                      delegates: LottieDelegates(
                                        values: [
                                          ValueDelegate.colorFilter(
                                            const [
                                              '**',
                                            ], // Wildcard matches all layers
                                            value: const ColorFilter.mode(
                                              Colors.blue,
                                              BlendMode.srcATop,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                            : Text(
                                "${songEntity.duration?.inMinutes}:${songEntity.duration?.inSeconds.remainder(60).toString().padLeft(2, '0') ?? "00"}",
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                        //SizedBox(width: 50),
                        itemSnapshot.data!.id == songEntity.id
                            ? IconButton.filledTonal(
                                // padding: EdgeInsets.all(-5),
                                onPressed: () {
                                  if (audioHandler
                                      .playbackState
                                      .value
                                      .playing) {
                                    audioHandler.pause();
                                  } else {
                                    audioHandler.play();
                                  }
                                },
                                icon: Icon(
                                  audioHandler.playbackState.value.playing
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.purpleAccent.shade700.withGreen(
                                    110,
                                  ),
                                ),
                              )
                            : FavoriteButton(
                                // key: UniqueKey(),
                                function: function,
                                songEntity: songEntity,
                                isFavorite: isFavorite,
                                color:
                                    activeColor ??
                                    Colors.purpleAccent.shade700.withGreen(100),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
