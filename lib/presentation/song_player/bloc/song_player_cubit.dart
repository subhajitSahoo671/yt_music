
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/presentation/song_player/bloc/song_player_state.dart';
import 'package:just_audio/just_audio.dart';

class SongPlayerCubit extends Cubit<SongPlayerState>{

  AudioPlayer audioPlayer = AudioPlayer();

  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  Timer? _positionTimer;

  SongPlayerCubit() : super(SongPlayerLoading()){
    // Keep the latest position locally but avoid emitting on every fast position event.
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
    },);

    // Duration changes are infrequent; emit when we learn the duration.
     audioPlayer.durationStream.listen((duration) {
      if(duration != null){
        songDuration = duration;
        //updateSongPlayer();
      }
    },);

    // Emit UI updates at a controlled interval to reduce main-thread rebuilds.
    _positionTimer = Timer.periodic(Duration(milliseconds: 300), (_) {
      updateSongPlayer();
    });
  }

  void updateSongPlayer() {
    emit(
     SongPlayerLoaded() 
    );
  }

  Future<void> loadSong(String url) async{
    try {
     await audioPlayer.setUrl(url);
      emit(SongPlayerLoaded());
    } catch (e) {
      emit(SongPlayerFailure());
    }
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.stop();
    } else {
      audioPlayer.play();
    }

    updateSongPlayer();   
  }

  @override
  Future<void> close() {
    _positionTimer?.cancel();
    audioPlayer.dispose();
    return super.close();
  }
}