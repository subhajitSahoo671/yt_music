import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:yt_music/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:yt_music/domain/usecases/song/add_or_remove_favorite_songs.dart';
import 'package:yt_music/domain/usecases/song/is_favorite_song.dart';
import 'package:yt_music/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:yt_music/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:yt_music/service_locator.dart';

class FavoriteButton extends StatefulWidget {
  final MediaItem songEntity;
  final Function? function;
  final Color color;
  final double? size;
  final bool? isFavorite;
  const FavoriteButton({super.key, required this.songEntity,  required this.color,  this.size , this.isFavorite, this.function});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {

 late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite ?? false;
    // _isFavorite();
  }

  Future<void> _isFavorite() async{
      isFavorite = await sl<IsFavoriteSongUseCase>().call(
          params: widget.songEntity.genre
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteSongsCubit,FavoriteSongsState>(
      builder: (context, state) {
        // bool isFavorite = widget.songEntity.playable!;
      if (state is FavoriteSongsLoading) {
        // return CircularProgressIndicator();
        // print("widget.songEntity ${widget.songEntity}");
    
        return IconButton(
                        onPressed: () async{
                        // await context.read<FavoriteButtonCubit>().favoriteButtonUpdated(
                        //     widget.songEntity
                        //   );
                        //   if (widget.function != null) {
                        //     widget.function!();
                        //   }
      print("isFavorite$isFavorite");

                        },
                          icon: Icon( 
                            isFavorite
                            ? Icons.favorite_rounded  
                            : Icons.favorite_border_rounded,
                          //  color: AppColors.greyText.withBlue(50).withValues(alpha: 100)
                          color: widget.color,
                          size: widget.size,
                          )
                        );
      }
       
       if (state is FavoriteSongsLoaded) {
        // print("state.favoriteSongs ${state.favoriteSongs}");
        // print("widget.songEntity ${widget.songEntity}");

        var data = state.favoriteSongs.where((e) {
          // print("hyjuj${e.genre }${ widget.songEntity.genre}");
          return e.genre == widget.songEntity.genre;
        },);
        
        if (data.isNotEmpty) {
          isFavorite = true;
        }else{
          isFavorite = false;
        }
        return IconButton(
                        onPressed: () async{
                          //   context.read<FavoriteButtonCubit>().favoriteButtonUpdated(
                          //   widget.songEntity
                          // );
                          final favoriteSongsCubit = context.read<FavoriteSongsCubit>();
                          var result = await sl<AddOrRemoveFavoriteSongsUseCase>().call(
      params: widget.songEntity
    );

      if (!mounted) return;

      print("isFavorite$isFavorite");

    result.fold((l) {
      print(l);
    }, (r) {
      print("isFavorite$isFavorite$r");
       isFavorite ? favoriteSongsCubit.removeSong(widget.songEntity): favoriteSongsCubit.addSong(widget.songEntity);
      print("isFavorite$isFavorite$r");
    
    },);
                     
                          // isFavorite = state.isFavorite;
                        },
                          icon: Icon( 
                            isFavorite
                            ? Icons.favorite_rounded  
                            : Icons.favorite_border_rounded,
                          //  color: AppColors.greyText.withBlue(50).withValues(alpha: 100)
                          color: widget.color,
                          size: widget.size,
                          )
                        );
      }
        return Container();
    },
    );
  }
}