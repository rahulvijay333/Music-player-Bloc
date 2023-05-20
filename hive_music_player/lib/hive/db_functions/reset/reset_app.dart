import 'package:flutter/material.dart';
import 'package:hive_music_player/hive/db_functions/favourites/fav_function.dart';
import 'package:hive_music_player/hive/db_functions/playlist/playlist_functions.dart';
import 'package:hive_music_player/hive/db_functions/splash/splash_functions.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/fav/fav_mode.dart';
import 'package:hive_music_player/hive/model/mostply_played/mosltly_played_model.dart';
import 'package:hive_music_player/hive/model/playlist/playlist_model.dart';
import 'package:hive_music_player/hive/model/recently_played/recently_model.dart';
import 'package:hive_music_player/screens/miniPlayer/mini_player.dart';
import 'package:hive_music_player/screens/now_playing/screen_now_playing.dart';
import 'package:hive_music_player/screens/splash/screen_splash.dart';

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

  favNotifier.value.clear();
  playlistNotifier.value.clear();

  justAudioPlayerObject.stop();
  globalMiniList.value.clear();

  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    builder: (context) {
      return const ScreenSplash();
    },
  ), (route) => false);
}
