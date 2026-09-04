import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yt_music/domain/entities/song/song.dart';

class SongModel {
  String? title;
  String? artist;
  num? duration;
  Timestamp? releaseDate;
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

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    releaseDate = data['releaseDate'];
    imageURL = data['imageURL'];
    songURL = data['songURL'];
    // songId = data["songId"];
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    // log(imageURL.toString());
    return SongEntity(
      title: title!,
      artist: artist!,
      duration: duration!,
      releaseDate: releaseDate!,
      imageURL: imageURL!,
      songURL: songURL!,
      // isFavorite: isFavorite!,
      songId: songId!
    );
  }
}
