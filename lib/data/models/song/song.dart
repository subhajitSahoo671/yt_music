import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yt_music/domain/entities/song/song.dart';

class SongModel {
  String? title;
  String? artist;
  num? duration;
  String? releaseDate;
  String? imageURL;
  String? songURL;
  // bool? isFavorite;
  String? songId;

  SongModel({
    required this.title,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.imageURL,
    required this.songURL,
    // required this.isFavorite,
    required this.songId
  });

  // SongModel.fromJson(Map<String, dynamic> data) {
  //   title = data['name'] ?? data["album_name"];
  //   artist = data['artist_name'] ?? "unknown";
  //   duration = data['duration'];
  //   releaseDate = data['releasedate'];
  //   imageURL = data['album_image'];
  //   songURL = data['audio'];
  //   // songId = data["songId"];
  // }

   SongModel.bollyFromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    releaseDate = data['releaseDate'].toString();
    imageURL = data['imageURL'];
    songURL = data['songURL'];
    // songId = data["id"];
  }

   SongModel.favFromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    // releaseDate = data['addedDate'].toString();
    imageURL = data['imageURL'];
    songURL = data['songURL'];
    songId = data["songId"];
  }

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artists'] ?? data["genre"] ?? "unknown";
    duration = data['duration'];
    releaseDate = data['created_at'] ?? data["updated_at"];
    imageURL = data['artwork']?["480x480"] ?? "https://img.magnific.com/premium-psd/music-note-3d-icon-with-musical-symbol-made-with-translucent-png-trendy-neon-color-shape_1020495-522146.jpg?semt=ais_hybrid&w=740&q=80";
    songURL = data['stream']?["url"] ?? "unknown";
    songId = data["id"];
  }
}

extension SongModelX on SongModel {
  MediaItem toMediaItem() {
    // print("songurl $songURL");
    // print("desi $imageURL");
    return MediaItem(
      title: title!,
      artist: artist!,
      duration: Duration(
            minutes: (duration!/60).toInt(),
            seconds:(duration!%60).toInt(),         
          ),
      // releaseDate: releaseDate!,
      artUri: Uri.tryParse(imageURL!),
      genre: songId!,
      // isFavorite: isFavorite!,
      id: songURL!,
      extras: {
        "songURL": songURL
      }
    );
  }
}
