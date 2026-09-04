import 'package:dartz/dartz.dart';
import 'package:yt_music/core/usecase/usecase.dart';
import 'package:yt_music/domain/repository/song/song.dart';
import 'package:yt_music/service_locator.dart';

class AddOrRemoveFavoriteSongsUseCase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async{
   return await sl<SongRepository>().addOrRemoveFavoriteSongs(params!);
  }
    
}