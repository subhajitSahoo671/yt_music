
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_music/core/configs/theme/app_theme.dart';
// import 'package:yt_music/presentation/auth/pages/signup_or_signin.dart';
// import 'package:yt_music/presentation/auth/pages/signup.dart';
// import 'package:yt_music/presentation/auth/pages/signin.dart';
import 'package:yt_music/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:yt_music/presentation/splash/pages/splash.dart';
import 'package:yt_music/service_locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yt_music/test.dart';
import 'firebase_options.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_service/audio_service.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';
import 'package:yt_music/presentation/profile/bloc/favorite_songs_cubit.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  
   await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );

  await initializeDependencies();

  // Request notification permission on Android 13+
  if (Platform.isAndroid) {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  // Initialize AudioService early so notifications / control center work (Android 13/14+)
  final audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.yt_music.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      //androidStopForegroundOnPause: false,
      // Use a monochrome drawable icon for notifications (white-only)
      // androidNotificationIcon: 'drawable/ic_notification',
    ),
  );

  // Register handler in service locator for later use in UI
  // ignore: unnecessary_cast
  sl.registerSingleton<MyAudioHandler>(audioHandler as MyAudioHandler);

  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => FavoriteSongsCubit()..getFavoriteSongs(),
        ),
      ],
      child: BlocBuilder<ThemeCubit,ThemeMode>(
        builder: (context, mode) => MaterialApp(
          //title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home:  const SplashPage(),
          // routes: {
          //   '/signup_or_signin': (context) => const SignupOrSignin(),
          //   '/signup': (context) => const SignupPage(),
          //   '/signin': (context) => const SigninPage(),
          // },
        ),
      ),
    );
  }
}

