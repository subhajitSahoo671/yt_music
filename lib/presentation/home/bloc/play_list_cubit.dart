
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/domain/usecases/song/get_bolly_hits.dart';
import 'package:yt_music/domain/usecases/song/get_play_list.dart';
import 'package:yt_music/domain/usecases/song/get_popular_album_week.dart';
import 'package:yt_music/domain/usecases/song/get_trending_month_playlist.dart';
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

  Future<void> getBollyHits() async {
    var  returnedSongs = await sl<GetBollyHitsUsecase>().call();

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

  Future<void> getTrendingOfTheMonthPlaylist() async {
    var  returnedPlaylist = await sl<GetTrendingMonthPlaylistUsecase>().call();

    if (isClosed) return;

    return returnedPlaylist.fold(
      (failure) {
        emit(PlayListLoadFailure());
        
      },
      (playlist) {
        emit(ListOfPlayListLoaded(playlist: playlist));
      },
    );
  }

  Future<void> getPopularAlbumOfTheWeek() async {
    var  returnedAlbums = await sl<GetPopularAlbumWeekUsecase>().call();

    if (isClosed) return;

    return returnedAlbums.fold(
      (failure) {
        emit(PlayListLoadFailure());
        
      },
      (albums) {
        emit(ListOfPlayListLoaded(playlist: albums));
      },
    );
  }
}