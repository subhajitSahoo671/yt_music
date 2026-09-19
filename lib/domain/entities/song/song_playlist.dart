
import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yt_music/data/models/song/song.dart';

class SongPlaylistEntity {
  final String playlistTitle;
 
  final String imageURL;
  final bool isAlbum;
  final List<MediaItem> tracks;
 

  SongPlaylistEntity({
    required this.playlistTitle,
   
    required this.imageURL,
    required this.isAlbum,
     required this.tracks,
    
    
  });
}