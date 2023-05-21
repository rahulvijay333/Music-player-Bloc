import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/application/all%20songs/all_songs_bloc.dart';
import 'package:hive_music_player/application/playlist/playlist_bloc.dart';
import 'package:hive_music_player/hive/db_functions/favourites/fav_function.dart';
import 'package:hive_music_player/hive/db_functions/mostly_played/moslty_played_function.dart';
import 'package:hive_music_player/hive/db_functions/recentlyPlayed/recently_function.dart';
import 'package:hive_music_player/screens/splash/screen_splash.dart';

import 'hive/db_functions/playlist/playlist_functions.dart';
import 'hive/model/fav/fav_mode.dart';
import 'hive/model/all_songs/model.dart';
import 'hive/model/mostply_played/mosltly_played_model.dart';
import 'hive/model/playlist/playlist_model.dart';
import 'hive/model/recently_played/recently_model.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(AudioModelAdapter().typeId)) {
    Hive.registerAdapter(AudioModelAdapter());
  }

  if (!Hive.isAdapterRegistered(RecentlyPlayedAdapter().typeId)) {
    Hive.registerAdapter(RecentlyPlayedAdapter());
  }

  if (!Hive.isAdapterRegistered(FavouritesAdapter().typeId)) {
    Hive.registerAdapter(FavouritesAdapter());
  }

  if (!Hive.isAdapterRegistered(MostlyPlayedAdapter().typeId)) {
    Hive.registerAdapter(MostlyPlayedAdapter());
  }

  if (!Hive.isAdapterRegistered(PlaylistAdapter().typeId)) {
    Hive.registerAdapter(PlaylistAdapter());
  }

  //open database for all 
  await Hive.openBox<AudioModel>(musicsDbName);
  await Hive.openBox<Playlist>(playlistDbName);

  //open database for recentplayed
  openRecentlyPlayed();

  //open databse for favourites
  openFavouritesDb();

  //open database for mostly played
  openMostlyPlayedDb();

  //open database for playlist
  // openPlaylistDb();

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
         
        )
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: ScreenSplash()),
    );
  }
}
