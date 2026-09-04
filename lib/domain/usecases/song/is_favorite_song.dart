// import 'package:dartz/dartz.dart';
import 'package:yt_music/core/usecase/usecase.dart';
import 'package:yt_music/domain/repository/song/song.dart';
import 'package:yt_music/service_locator.dart';

class IsFavoriteSongUseCase implements Usecase<bool, String> {
  @override
  Future<bool> call({String? params}) async{
   return await sl<SongRepository>().isFavoriteSong(params!);
  }
    
}