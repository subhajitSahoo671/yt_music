import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:yt_music/domain/usecases/song/add_or_remove_favorite_songs.dart';
import 'package:yt_music/service_locator.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState>{

  FavoriteButtonCubit(): super(FavoriteButtonInitial());

  Future<void> favoriteButtonUpdated(MediaItem songEntity) async{
    var result = await sl<AddOrRemoveFavoriteSongsUseCase>().call(
      params: songEntity
    );

    if (isClosed) return;

    result.fold((l) {
      
    }, (r) {
      emit(
        FavoriteButtonUpdated(
          isFavorite: r
        )
      );
    },);
  }
}