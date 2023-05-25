import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:hive_music_player/application/RecentlyPlayed/recently_played_bloc.dart';
import 'package:hive_music_player/application/all%20songs/all_songs_bloc.dart';
import 'package:hive_music_player/application/favourites/favourites_bloc.dart';
import 'package:hive_music_player/application/miniPlayer/mini_player_bloc.dart';
import 'package:hive_music_player/application/playlist/playlist_bloc.dart';
import 'package:hive_music_player/presentation/splash/screen_splash.dart';
import 'domain/model/fav/fav_mode.dart';
import 'domain/model/all_songs/model.dart';
import 'domain/model/mostply_played/mosltly_played_model.dart';
import 'domain/model/playlist/playlist_model.dart';
import 'domain/model/recently_played/recently_model.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(AudioModelAdapter().typeId)) {
    Hive.registerAdapter(AudioModelAdapter());
  }
  await Hive.openBox<AudioModel>(musicsDbName);

  if (!Hive.isAdapterRegistered(RecentlyPlayedAdapter().typeId)) {
    Hive.registerAdapter(RecentlyPlayedAdapter());
  }
  await Hive.openBox<RecentlyPlayed>(recentlyDbName);

  if (!Hive.isAdapterRegistered(FavouritesAdapter().typeId)) {
    Hive.registerAdapter(FavouritesAdapter());
  }
  await Hive.openBox<Favourites>(favBoxName);

  if (!Hive.isAdapterRegistered(MostlyPlayedAdapter().typeId)) {
    Hive.registerAdapter(MostlyPlayedAdapter());
  }
  await Hive.openBox<MostlyPlayed>(mostlyPlayedDbName);

  if (!Hive.isAdapterRegistered(PlaylistAdapter().typeId)) {
    Hive.registerAdapter(PlaylistAdapter());
  }

  //open database for all

  await Hive.openBox<Playlist>(playlistDbName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AllSongsBloc(),
        ),
        BlocProvider(
          create: (context) => PlaylistBloc(),
        ),
        BlocProvider(
          create: (context) => RecentlyPlayedBloc(),
        ),
        BlocProvider(
          create: (context) => FavouritesBloc(),
        ),
        BlocProvider(
          create: (context) => MostlyPlayedBloc(),
        ),
        BlocProvider(
          create: (context) => MiniPlayerBloc(),
        )
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: ScreenSplash()),
    );
  }
}
