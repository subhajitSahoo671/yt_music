import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/domain/entities/song/song.dart';
import 'package:yt_music/domain/usecases/song/get_favorite_songs.dart';
import 'package:yt_music/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:yt_music/service_locator.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  FavoriteSongsCubit(): super(FavoriteSongsLoading());

  List<MediaItem> favoriteSongs = [];

  Future<void> getFavoriteSongs() async {
    try {
      final result = await sl<GetFavoriteSongsUsecase>().call();

      if (isClosed) return; // avoid emitting after disposal


      result.fold(
        (l) {
          if (!isClosed) emit(FavoriteSongsFailure());
        },
        (r) {
          favoriteSongs = r;
        // print("state.favoriteSongs $favoriteSongs");

          if (!isClosed) emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
        },
      );
    } catch (e) {
      log(  'error: $e');
      if (!isClosed) emit(FavoriteSongsFailure());
    }
  }
  

  void removeSong(MediaItem song) {
    favoriteSongs.remove(song);
    if (!isClosed) emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
  }

  void addSong(MediaItem song) {
    favoriteSongs.add(song);
    if (!isClosed) emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
  }
}