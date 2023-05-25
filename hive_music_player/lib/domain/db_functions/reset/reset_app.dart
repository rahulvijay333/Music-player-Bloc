import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:hive_music_player/application/miniPlayer/mini_player_bloc.dart';
import 'package:hive_music_player/domain/db_functions/splash/splash_functions.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
import 'package:hive_music_player/domain/model/fav/fav_mode.dart';
import 'package:hive_music_player/domain/model/mostply_played/mosltly_played_model.dart';
import 'package:hive_music_player/domain/model/playlist/playlist_model.dart';
import 'package:hive_music_player/domain/model/recently_played/recently_model.dart';
import 'package:hive_music_player/presentation/miniPlayer/mini_player.dart';
import 'package:hive_music_player/presentation/now_playing/screen_now_playing.dart';
import 'package:hive_music_player/presentation/splash/screen_splash.dart';

resetApp(BuildContext context) async {
  final mostplayedbox = MostplePlayedBox.getInstance();
  await mostplayedbox.clear();

 
  final recentlyplayedBox = RecentlyPlayedBox.getinstance();
  await recentlyplayedBox.clear();

  final favouritesbox = FavouriteBox.getinstance();
  await favouritesbox.clear();

  final allsongsBox = MusicBox.getInstance();
  await allsongsBox.clear();

  final playlistBox = PlaylistBox.getInstance();
  await playlistBox.clear();

  await refreshDatabaseFunction();

  updatingList.value.clear();

  justAudioPlayerObject.stop();
  BlocProvider.of<MiniPlayerBloc>(context).add(CloseMiniPlayer());

  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    builder: (context) {
      return const ScreenSplash();
    },
  ), (route) => false);
}
