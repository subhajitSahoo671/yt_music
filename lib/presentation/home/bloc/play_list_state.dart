// import 'dart:developer';

import 'package:audio_service/audio_service.dart';
// import 'package:yt_music/data/models/song/song.dart';
import 'package:yt_music/domain/entities/song/song.dart';

abstract class PlayListState {}

class PlayListLoading extends PlayListState {}

class PlayListLoaded extends PlayListState {
  final List<SongEntity> songs;

  PlayListLoaded({required this.songs});

  Future<List<MediaItem>> getMediaItems() async {
    List<MediaItem> items = [];

    for (SongEntity song in songs) {
      // log("Processing song: ${double.parse(song.duration.toString())}");
      
      items.add(
        MediaItem(
          id: song.songURL,
          // album: song.album ?? 'Unknown Album',
          title: song.title,
          artist: song.artist,
          artUri: Uri.parse(song.imageURL),
          // playable: song.isFavorite,
          genre: song.songId,
          // genre: song.duration.toString(),
          duration: Duration(
            minutes: double.parse(song.duration.toString()).toInt(),
            seconds: ((double.parse(song.duration.toString()) -
                            double.parse(song.duration.toString()).toInt()) * 100).ceil(),         
          ),
        ),
      );
    }

    return items;
  }
}

class PlayListLoadFailure extends PlayListState {}
