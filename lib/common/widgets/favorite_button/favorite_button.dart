import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:yt_music/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:yt_music/domain/usecases/song/is_favorite_song.dart';
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
    _isFavorite();
  }

  Future<void> _isFavorite() async{
      isFavorite = await sl<IsFavoriteSongUseCase>().call(
          params: widget.songEntity.genre
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => FavoriteButtonCubit(),
    child: BlocBuilder<FavoriteButtonCubit,FavoriteButtonState>(
      builder: (context, state) {
        // bool isFavorite = widget.songEntity.playable!;
      if (state is FavoriteButtonInitial) {
        return IconButton(
                        onPressed: () async{
                        await context.read<FavoriteButtonCubit>().favoriteButtonUpdated(
                            widget.songEntity.genre!
                          );
                          if (widget.function != null) {
                            widget.function!();
                          }
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
       
       if (state is FavoriteButtonUpdated) {
        return IconButton(
                        onPressed: () {
                            context.read<FavoriteButtonCubit>().favoriteButtonUpdated(
                            widget.songEntity.genre!
                          );

                          // isFavorite = state.isFavorite;
                        },
                          icon: Icon( 
                            state.isFavorite
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
    ),
    );
  }
}