import 'package:yt_music/data/data_sources/auth/auth_firebase_servise.dart';
import 'package:yt_music/data/data_sources/song/song_audius_servise.dart';
import 'package:yt_music/data/data_sources/song/song_firebase_servise.dart';
import 'package:yt_music/data/data_sources/song/song_jamendo_servise.dart';
import 'package:yt_music/data/repository/auth/auth_repository_impl.dart';
import 'package:yt_music/data/repository/song/song_repository_impl.dart';
import 'package:yt_music/domain/repository/auth/auth.dart';
import 'package:yt_music/domain/repository/song/song.dart';
import 'package:yt_music/domain/usecases/auth/get_user.dart';
import 'package:yt_music/domain/usecases/auth/signin.dart';
import 'package:yt_music/domain/usecases/auth/signup.dart';
import 'package:yt_music/domain/usecases/song/add_or_remove_favorite_songs.dart';
import 'package:yt_music/domain/usecases/song/get_bolly_hits.dart';
import 'package:yt_music/domain/usecases/song/get_favorite_songs.dart';
import 'package:yt_music/domain/usecases/song/get_news_songs.dart';
import 'package:yt_music/domain/usecases/song/get_play_list.dart';
import 'package:yt_music/domain/usecases/song/get_popular_album_week.dart';
import 'package:yt_music/domain/usecases/song/get_trending_month_playlist.dart';
import 'package:yt_music/domain/usecases/song/is_favorite_song.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
   
   sl.registerSingleton<AuthFirebaseServise>(
    AuthFirebaseServiseImpl()
   );

   sl.registerSingleton<SongFirebaseServise>(
    SongFirebaseServiseImpl()
   );

    sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl()
   );

   sl.registerSingleton<SongRepository>(
    SongRepositoryImpl()
   );

    sl.registerSingleton<SignupUseCase>(
    SignupUseCase()
   );

    sl.registerSingleton<SigninUseCase>(
    SigninUseCase()
   );

   sl.registerSingleton<GetNewsSongsUsecase>(
    GetNewsSongsUsecase()
   );

   sl.registerSingleton<GetPlayListUsecase>(
    GetPlayListUsecase()
   );

   sl.registerSingleton<GetBollyHitsUsecase>(
    GetBollyHitsUsecase()
   );

   sl.registerSingleton<GetTrendingMonthPlaylistUsecase>(
    GetTrendingMonthPlaylistUsecase()
   );

   sl.registerSingleton<GetPopularAlbumWeekUsecase>(
    GetPopularAlbumWeekUsecase()
   );

   sl.registerSingleton<AddOrRemoveFavoriteSongsUseCase>(
    AddOrRemoveFavoriteSongsUseCase()
   );

   sl.registerSingleton<IsFavoriteSongUseCase>(
    IsFavoriteSongUseCase()
    );
    
    sl.registerSingleton<GetUserUseCase>(
    GetUserUseCase()
   );

   sl.registerSingleton<GetFavoriteSongsUsecase>(
    GetFavoriteSongsUsecase()
   );

   sl.registerSingleton<AudiusService>(
    AudiusService()
   );

  //  sl.registerSingleton<JamendoService>(
  //   JamendoService()
  //  );
}