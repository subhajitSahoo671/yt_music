//import 'dart:math';

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yt_music/data/models/song/song.dart';
import 'package:yt_music/domain/entities/song/song.dart';
// import 'package:yt_music/domain/usecases/song/is_favorite_song.dart';
// import 'package:yt_music/service_locator.dart';

abstract class SongFirebaseServise {
  Future<Either> getNewsSongs();
  Future<Either> getPlayList();
  Future<Either> addOrRemoveFavoriteSongs(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Either> getUserFavoriteSongs();
}

class SongFirebaseServiseImpl extends SongFirebaseServise {
  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('songs')
          .orderBy('releaseDate', descending: true)
          .limit(3)
          .get();

      for (var doc in data.docs) {
        var songModel = SongModel.fromJson(doc.data());
        // bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
        //   params: doc.reference.id
        // );
        // songModel.isFavorite = isFavorite;
        songModel.songId = doc.reference.id;
        songs.add(songModel.toEntity());
      }

      return right(songs);
    } on FirebaseException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either> getPlayList() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('songs')
          .orderBy('releaseDate')
          .get();

      for (var doc in data.docs) {
        var songModel = SongModel.fromJson(doc.data());
        //  bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
        //   params: doc.reference.id
        // );
        // songModel.isFavorite = isFavorite;
        songModel.songId = doc.reference.id;
        songs.add(songModel.toEntity());
      }

      return right(songs);
    } on FirebaseException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteSongs(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavorite;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection("Users")
          .doc(uId)
          .collection("Favorites")
          .where("songId", isEqualTo: songId)
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        await favoriteSongs.docs.first.reference.delete();
        isFavorite = false;
      } else {
        await firebaseFirestore
            .collection("Users")
            .doc(uId)
            .collection("Favorites")
            .add({"songId": songId, "addedDate": Timestamp.now()});
        isFavorite = true;
      }

      return right(isFavorite);
    } catch (e) {
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
      List<SongEntity> favoriteSongsList = [];
      String uId = user!.uid;

       QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection("Users")
          .doc(uId)
          .collection("Favorites")
          .get();

          for (var doc in favoriteSongs.docs) {
            String songId = doc["songId"];
            var songData = await firebaseFirestore.collection("songs").doc(songId).get();
            var songModel = SongModel.fromJson(songData.data()!);
             songModel.songId = songId;
            favoriteSongsList.add(songModel.toEntity());
          }

          return right(favoriteSongsList);
    } catch (e) {
      log("$e");
      return left("An error occurred");
    }
  }
}
