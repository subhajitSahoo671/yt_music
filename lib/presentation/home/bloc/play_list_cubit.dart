
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/domain/usecases/song/get_play_list.dart';
import 'package:yt_music/presentation/home/bloc/play_list_state.dart';
import 'package:yt_music/service_locator.dart';

class PlayListCubit extends Cubit<PlayListState> {
  
  //PlayListCubit(super.initialState);
  PlayListCubit() : super(PlayListLoading());

  Future<void> getPlayList() async {
    var  returnedSongs = await sl<GetPlayListUsecase>().call();

    if (isClosed) return;

    return returnedSongs.fold(
      (failure) {
        emit(PlayListLoadFailure());
        
      },
      (songs) {
        emit(PlayListLoaded(songs: songs));
      },
    );
  }
}