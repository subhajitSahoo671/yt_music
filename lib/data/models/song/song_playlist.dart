import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yt_music/data/models/song/song.dart';
import 'package:yt_music/domain/entities/song/song.dart';
import 'package:yt_music/domain/entities/song/song_playlist.dart';

class SongPlaylistModel {
  String? playlistTitle;
  String? playlistDescription;
  String? imageURL;
  bool? isAlbum;
  List<MediaItem>? tracks;

  SongPlaylistModel({
    required this.playlistTitle,
    required this.playlistDescription,
    required this.imageURL,
    required this.isAlbum,
    required this.tracks,
   
  });

  SongPlaylistModel.fromJson(Map<String, dynamic> data) {
    playlistTitle = data['playlist_name'] ?? data["description"];
    playlistDescription = data["description"] ?? data['playlist_name'];
    imageURL = data['artwork']?["480x480"] ?? "https://img.magnific.com/premium-psd/music-note-3d-icon-with-musical-symbol-made-with-translucent-png-trendy-neon-color-shape_1020495-522146.jpg?semt=ais_hybrid&w=740&q=80";
    isAlbum = data["is_album"];
      tracks = List<MediaItem>.from(
        (data["tracks"] as List<dynamic>).map<MediaItem>(
          (track) => SongModel.fromJson(track as Map<String, dynamic>).toMediaItem(),
        ),
      );
  }
}

extension SongModelX on SongPlaylistModel {
  SongPlaylistEntity toEntity() {
    // print("songurl $songURL");
    // print("desi $imageURL");
    return SongPlaylistEntity(
      playlistTitle : playlistTitle!,
     playlistDescription : playlistDescription!,
      imageURL: imageURL!,
      isAlbum : isAlbum!,
      tracks : tracks!
    );
  }
}
