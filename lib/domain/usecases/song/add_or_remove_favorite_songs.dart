import 'package:audio_service/audio_service.dart';
import 'package:dartz/dartz.dart';
import 'package:yt_music/core/usecase/usecase.dart';
import 'package:yt_music/domain/repository/song/song.dart';
import 'package:yt_music/service_locator.dart';

class AddOrRemoveFavoriteSongsUseCase implements Usecase<Either, MediaItem> {
  @override
  Future<Either> call({MediaItem? params}) async{
   return await sl<SongRepository>().addOrRemoveFavoriteSongs(params!);
  }
    
}