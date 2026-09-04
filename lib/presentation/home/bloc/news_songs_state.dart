import 'package:audio_service/audio_service.dart';
import 'package:yt_music/domain/entities/song/song.dart';

abstract class NewsSongsState {}

class NewsSongsLoading extends NewsSongsState {}

class NewsSongsLoaded extends NewsSongsState {
  final List<SongEntity> songs;

  NewsSongsLoaded({required this.songs});

   Future<List<MediaItem>> getMediaItems() async {
    List<MediaItem> items = [];

    for (SongEntity song in songs) {
      items.add(
        MediaItem(
          id: song.songURL,
          // playable: song.isFavorite,
          genre: song.songId,
          // album: song.album ?? 'Unknown Album',
          title: song.title,
          artist: song.artist,
          artUri: Uri.parse(song.imageURL),
          duration: Duration(seconds: song.duration.toInt()),
        ),
      );
    }

    return items;
  }
}

class NewsSongsLoadFailure extends NewsSongsState {}