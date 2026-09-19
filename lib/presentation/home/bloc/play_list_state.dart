// import 'dart:developer';

import 'package:audio_service/audio_service.dart';
// import 'package:yt_music/data/models/song/song.dart';
import 'package:yt_music/domain/entities/song/song.dart';
import 'package:yt_music/domain/entities/song/song_playlist.dart';

abstract class PlayListState {}

class PlayListLoading extends PlayListState {}

class PlayListLoaded extends PlayListState {
  final List<MediaItem> songs;

  PlayListLoaded({required this.songs});

  // Future<List<MediaItem>> getMediaItems() async {
  //   List<MediaItem> items = [];

  //   for (MediaItem song in songs) {
  //     // log("Processing song: ${double.parse(song.duration.toString())}");
      
  //     items.add(
  //       MediaItem(
  //         id: song.songURL,
  //         // album: song.album ?? 'Unknown Album',
  //         title: song.title,
  //         artist: song.artist,
  //         artUri: Uri.tryParse(song.imageURL),
  //         // playable: song.isFavorite,
  //         genre: song.songId,
  //         // genre: song.duration.toString(),
  //         duration: Duration(
  //           minutes: (song.duration/60).toInt(),
  //           seconds:(song.duration%60).toInt(),         
  //         ),
  //       ),
  //     );
  //   }

  //   return items;
  // }
}

class ListOfPlayListLoaded extends PlayListState {
  final List<SongPlaylistEntity> playlist;

  ListOfPlayListLoaded({required this.playlist});

  // Future<List<List<MediaItem>>> getMediaItems() async {
  
  //   List<List<MediaItem>> playlstItems = [];

  //  for(var songs in playlist){
  //     List<MediaItem> items = [];
  //    for (SongEntity song in songs) {
  //     // log("Processing song: ${double.parse(song.duration.toString())}");
      
  //     items.add(
  //       MediaItem(
  //         id: song.songURL,
  //         // album: song.album ?? 'Unknown Album',
  //         title: song.title,
  //         artist: song.artist,
  //         artUri: Uri.tryParse(song.imageURL),
  //         // playable: song.isFavorite,
  //         genre: song.songId,
  //         // genre: song.duration.toString(),
  //         duration: Duration(
  //           minutes: (song.duration/60).toInt(),
  //           seconds:(song.duration%60).toInt(),         
  //         ),
  //       ),
  //     );
  //   }
  //   playlstItems.add(items);
  //  }

  //   return playlstItems;
  // }
}

class PlayListLoadFailure extends PlayListState {}
