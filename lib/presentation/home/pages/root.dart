import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';
import 'package:yt_music/service_locator.dart';
import 'package:yt_music/presentation/home/bloc/play_list_cubit.dart';
import 'package:yt_music/presentation/home/bloc/play_list_state.dart';
import 'package:yt_music/presentation/home/pages/home.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  late final MyAudioHandler _audioHandler;

  @override
  void initState() {
    super.initState();
    // Use the globally-registered audio handler (initialized in main)
    _audioHandler = sl<MyAudioHandler>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
    providers: [  
      BlocProvider<PlayListCubit>(create: (context) => PlayListCubit()..getBollyHits(), ),
          ],
              child: BlocBuilder<PlayListCubit, PlayListState>(
                builder: (context, state) {
                  if (state is PlayListLoading) {
                    return Container(
                       alignment: Alignment.center,
                       child: CircularProgressIndicator.adaptive(),
                         );
                      }
                 if (state is PlayListLoaded) {
                  return HomePage(
                              audioHandler: _audioHandler,
                              songs: state.songs,
                            );
                  
                }
                return Container();
                 
                }//
              )//
              );
  }
}