//import 'dart:math';

import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yt_music/data/data_sources/song/song_audius_servise.dart';
// import 'package:yt_music/data/data_sources/song/song_jamendo_servise.dart';
import 'package:yt_music/data/models/song/song.dart';
import 'package:yt_music/data/models/song/song_playlist.dart';
import 'package:yt_music/domain/entities/song/song.dart';
import 'package:yt_music/domain/entities/song/song_playlist.dart';
import 'package:yt_music/service_locator.dart';
// import 'package:yt_music/domain/usecases/song/is_favorite_song.dart';
// import 'package:yt_music/service_locator.dart';

abstract class SongFirebaseServise {
  Future<Either> getNewsSongs();
  Future<Either> getPlayList();
  Future<Either> getBollywoodHits();
  Future<Either> getTrendingsInMonth();
  Future<Either> getPopularAlbumOfWeek();
  Future<Either> addOrRemoveFavoriteSongs(MediaItem songEntity);
  Future<bool> isFavoriteSong(String songId);
  Future<Either> getUserFavoriteSongs();
}

class SongFirebaseServiseImpl extends SongFirebaseServise {
  @override
  Future<Either> getNewsSongs() async {
    try {
      List<MediaItem> songs = [];
      // var data = await FirebaseFirestore.instance
      //     .collection('songs')
      //     .orderBy('releaseDate', descending: true)
      //     .limit(3)
      //     .get();

      var data = await sl<AudiusService>().fetchLatestTracks();

      // print("pkpk : $data");

      for (var doc in data) {
        var songModel = SongModel.fromJson(doc);
        // bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
        //   params: doc.reference.id
        // );
        // songModel.isFavorite = isFavorite;
        // songModel.songId = doc["id"];
        songs.add(songModel.toMediaItem());
      }

      return right(songs);
    } on FirebaseException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either> getPlayList() async {
    try {
      List<MediaItem> songs = [];
      // var data = await FirebaseFirestore.instance
      //     .collection('songs')
      //     .orderBy('releaseDate')
      //     .get();

    var data = await sl<AudiusService>().fetchTrendingTracks();

    // print("jjpk: $data");

      for (var doc in data) {
        var songModel = SongModel.fromJson(doc);
        //  bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
        //   params: doc.reference.id
        // );
        // songModel.isFavorite = isFavorite;
        // songModel.songId = doc["id"];
        songs.add(songModel.toMediaItem());
      }

      return right(songs);
    } on FirebaseException catch (e) {
      return left(e.message);
    }
  }

   @override
  Future<Either<dynamic, dynamic>> getBollywoodHits() async{
    try {
      List<MediaItem> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('songs')
          .orderBy('releaseDate')
          .get();

    // var data = await sl<AudiusService>().fetchTrendingTracks();

    // print("bbol: $data");

      for (var doc in data.docs) {
        var songModel = SongModel.bollyFromJson(doc.data());
        //  bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
        //   params: doc.reference.id
        // );
        // songModel.isFavorite = isFavorite;
        songModel.songId = doc.reference.id;
        songs.add(songModel.toMediaItem());
      }

      return right(songs);
    } on FirebaseException catch (e) {
      return left(e.message);
    }
  }

   @override
  Future<Either<dynamic, dynamic>> getTrendingsInMonth() async{
     try {
      
      List<SongPlaylistEntity> playlist = [];
      // var data = await FirebaseFirestore.instance
      //     .collection('songs')
      //     .orderBy('releaseDate')
      //     .get();

    var data = await sl<AudiusService>().fetchTrendingsInMonth();

    // print("bbol: ${data.length}");

      for(var tracks in data){
        // List<SongPlaylistEntity> songs = [];
        // print("no of tracks in playlist= ${tracks["tracks"].length}");
        // for (var track in tracks["tracks"]) {
        // print("no of track in each tracks= ${track.length}");
        var songPlaylistModel = SongPlaylistModel.fromJson(tracks);
        //  bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
        //   params: track.reference.id
        // );
        // songModel.isFavorite = isFavorite;
        // songModel.songId = track["id"];
      //   songs.add(songPlaylistModel.toEntity());
      //   // print("huhu${songs.length}");
      // }
        // print("huhu${songs.length}");

      playlist.add(songPlaylistModel.toEntity());
      }

      return right(playlist);
    } on FirebaseException catch (e) {
      return left(e.message);
    }
  }

   @override
  Future<Either<dynamic, dynamic>> getPopularAlbumOfWeek() async{
     try {
      
      List<SongPlaylistEntity> albums = [];
    

    var data = await sl<AudiusService>().fetchPopularAlbumOfWeek();

    // print("bbol: ${data.length}");

      for(var tracks in data){
        // List<SongPlaylistEntity> songs = [];
        // print("no of tracks in albums= ${tracks["tracks"].length}");
        // for (var track in tracks["tracks"]) {
        // print("no of track in each tracks= ${track.length}");
        var songPlaylistModel = SongPlaylistModel.fromJson(tracks);
        //  bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
        //   params: track.reference.id
        // );
        // songModel.isFavorite = isFavorite;
        // songModel.songId = track["id"];
      //   songs.add(songModel.toEntity());
      //   // print("huhu${songs.length}");
      // }
        // print("huhu${songs.length}");

      albums.add(songPlaylistModel.toEntity());
      }

      return right(albums);
    } on FirebaseException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteSongs(MediaItem songEntity) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavorite;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      print("jjjdjdj");

      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection("Users")
          .doc(uId)
          .collection("Favorites")
          .where("songId", isEqualTo: songEntity.genre)
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        print("favoriteSongsNotEmpty");

        await favoriteSongs.docs.first.reference.delete();
        isFavorite = false;
      } else {
        print("favoriteSongsEmpty");
        await firebaseFirestore
            .collection("Users")
            .doc(uId)
            .collection("Favorites")
            .doc(songEntity.genre).set(
              {
                "songId" : songEntity.genre,
                "artist" : songEntity.artist,
                "duration" : songEntity.duration?.inSeconds,
                "imageURL" : songEntity.artUri?.toString(),
                "songURL" : songEntity.extras!["songURL"],
                "title" : songEntity.title, 
                "addedDate": Timestamp.now()
                }
                );
        isFavorite = true;
      }

      return right(isFavorite);
    } on FirebaseException catch (e) {
      print("FirebaseException occurs : ${e.message}");
      return left("An error occurred");
    }
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection("Users")
          .doc(uId)
          .collection("Favorites")
          .where("songId", isEqualTo: songId)
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<Either> getUserFavoriteSongs() async{
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = firebaseAuth.currentUser;
      List<MediaItem> favoriteSongsList = [];
      String uId = user!.uid;

       var favoriteSongs = await firebaseFirestore
          .collection("Users")
          .doc(uId)
          .collection("Favorites")
          .get();

          for (var doc in favoriteSongs.docs) {
            // String songId = doc["songId"];
            // var songData = await firebaseFirestore.collection("songs").doc(songId).get();
            var songModel = SongModel.favFromJson(doc.data());
             songModel.songId = doc.reference.id;
             print("docreference${doc.reference.id}");
             print("docid${doc.id}");
            favoriteSongsList.add(songModel.toMediaItem());
          }

          return right(favoriteSongsList);
    } catch (e) {
      log("$e");
      return left("An error occurred");
    }
  }

 

 

}
