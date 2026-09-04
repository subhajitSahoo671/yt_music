import 'dart:async';
import 'dart:developer';
// import 'dart:developer';

import 'package:audio_service/audio_service.dart';
 //import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler{

  AudioPlayer audioPlayer=AudioPlayer();
  
  // Stream subscriptions to manage and prevent duplicates
  StreamSubscription? _playbackEventSubscription;
  StreamSubscription? _processingStateSubscription;
  StreamSubscription? _currentIndexSubscription;
  
  
  UriAudioSource _createAudioSource(MediaItem item){
    return ProgressiveAudioSource(Uri.parse(item.id));
  }

  void _listenForCurrentSongIndexChanges(){
    // Cancel existing subscription to avoid duplicates
    _currentIndexSubscription?.cancel();
    
    _currentIndexSubscription = audioPlayer.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if(index != null && playlist.length > index){
        mediaItem.add(playlist[index]);
      } 
    });
  }

  //boardcast the current playback state of the audio player based on the received playbackevent
  
  void _boardcastState(PlaybackEvent event){
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if(audioPlayer.playing) MediaControl.pause else MediaControl.play,
          // MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0,1,3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[audioPlayer.processingState]!,
        playing: audioPlayer.playing,
        updatePosition: audioPlayer.position,
        bufferedPosition: audioPlayer.bufferedPosition,
        speed: audioPlayer.speed,
        queueIndex: event.currentIndex,
        // repeatMode: audioPlayer.loopMode == LoopMode.one ? AudioServiceRepeatMode.one : 
        //             audioPlayer.loopMode == LoopMode.all ? AudioServiceRepeatMode.all : 
        //             AudioServiceRepeatMode.none,
        // shuffleMode: audioPlayer.shuffleModeEnabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
      )
    );
  }

   // function to initialize the audio player with a list of songs
  Future<void> initSongs({required List<MediaItem> songs}) async{
    try {
      // Cancel existing subscriptions to avoid duplicates
      _playbackEventSubscription?.cancel();
      _processingStateSubscription?.cancel();
      
      _playbackEventSubscription = audioPlayer.playbackEventStream.listen(_boardcastState);
      
      final audioSource = songs.map(_createAudioSource).toList();

      await audioPlayer.setAudioSources(audioSource);

      //add the songs to the queue
      final newQueue = queue.value..addAll(songs);  
      queue.add(newQueue);

      // Ensure we have a current mediaItem for the notification/controls
      if (newQueue.isNotEmpty && mediaItem.value == null) {
        mediaItem.add(newQueue[0]);
      }

      //listen for changes in the current song index
      _listenForCurrentSongIndexChanges();

    // Handle completion of a song to automatically skip to the next one
      _processingStateSubscription = audioPlayer.processingStateStream.listen((state) {
        log("Processing state: $state");
        if(state == ProcessingState.completed){
          skipToNext();
        }
      }, onError: (error) {
        log("Error in processing state stream: $error");
      });
    } catch (e) {
      log("Error initializing songs: $e");
    }
  }

  //play fuction to start playback
  @override
  Future<void> play() async {
    try {
      await audioPlayer.play();
    } catch (e) {
      log("Error playing audio: $e");
    }
  }

  //pause function to pause playback
  @override
  Future<void> pause() async {
    try {
      await audioPlayer.pause();
    } catch (e) {
      log("Error pausing audio: $e");
    }
  }

  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  //skip to a specific song in the queue and start playback
  @override
  Future<void> skipToQueueItem(int index) async{
    try {
      if(index < 0 || index >= queue.value.length) return;
      await audioPlayer.seek(Duration.zero, index: index);
      await play();
    } catch (e) {
      log("Error skipping to queue item: $e");
    }
  }

  //skip to the next song in the queue
  @override
  Future<void> skipToNext() async {
    try {
      await audioPlayer.seekToNext();
    } catch (e) {
      log("Error skipping to next: $e");
    }
  }

  //skip to the previous song in the queue
  @override
  Future<void> skipToPrevious() async {
    try {
      await audioPlayer.seekToPrevious();
    } catch (e) {
      log("Error skipping to previous: $e");
    }
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {  
     playbackState.add(
      playbackState.value.copyWith(
        repeatMode: repeatMode,
      )
    );
     audioPlayer.setLoopMode(
      repeatMode == AudioServiceRepeatMode.one ? LoopMode.one : 
      repeatMode == AudioServiceRepeatMode.all ? LoopMode.all : 
      LoopMode.off
    );
    
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enable = shuffleMode == AudioServiceShuffleMode.all;
    audioPlayer.setShuffleModeEnabled(enable);
    playbackState.add(
      playbackState.value.copyWith(
        shuffleMode: shuffleMode,
      )
    );
  }

  // Cleanup method to dispose of subscriptions
  void dispose() {
    _playbackEventSubscription?.cancel();
    _processingStateSubscription?.cancel();
    _currentIndexSubscription?.cancel();
    audioPlayer.dispose();
  }
}