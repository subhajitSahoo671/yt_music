import 'package:dartz/dartz.dart';
import 'package:yt_music/data/data_sources/song/song_firebase_servise.dart';
import 'package:yt_music/domain/repository/song/song.dart';
import 'package:yt_music/service_locator.dart';

class SongRepositoryImpl extends SongRepository {
  @override
  Future<Either> getNewsSongs() async{
   return await sl<SongFirebaseServise>().getNewsSongs();
  }
  
  @override
  Future<Either> getPlayList() async {
    return await sl<SongFirebaseServise>().getPlayList();
  }
  
  @override
  Future<Either> addOrRemoveFavoriteSongs(String songId) async {
      return await sl<SongFirebaseServise>().addOrRemoveFavoriteSongs(songId);
  }
  
  @override
  Future<bool> isFavoriteSong(String songId) async {
      return await sl<SongFirebaseServise>().isFavoriteSong(songId);
    
  }
  
  @override
  Future<Either> getUserFavoriteSongs() {
    return sl<SongFirebaseServise>().getUserFavoriteSongs();
  }
  
}