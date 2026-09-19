import 'package:audio_service/audio_service.dart';
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
  Future<Either<dynamic, dynamic>> getBollywoodHits() async{
   return await sl<SongFirebaseServise>().getBollywoodHits();
  }

  @override
  Future<Either<dynamic, dynamic>> getTrendingsInMonth() async{
   return await sl<SongFirebaseServise>().getTrendingsInMonth();
  }

  @override
  Future<Either<dynamic, dynamic>> getPopularAlbumOfWeek() async{
   return await sl<SongFirebaseServise>().getPopularAlbumOfWeek();
  }
  
  @override
  Future<Either> addOrRemoveFavoriteSongs(MediaItem songEntity) async {
      return await sl<SongFirebaseServise>().addOrRemoveFavoriteSongs(songEntity);
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