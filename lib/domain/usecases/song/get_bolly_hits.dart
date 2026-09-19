import 'package:dartz/dartz.dart';
import 'package:yt_music/core/usecase/usecase.dart';
import 'package:yt_music/domain/repository/song/song.dart';
import 'package:yt_music/service_locator.dart';

class GetBollyHitsUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async{
   return await sl<SongRepository>().getBollywoodHits();
  }
    
}