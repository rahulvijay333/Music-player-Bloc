import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rythem_rider/application/now_playing/bloc/now_playing_bloc.dart';
import 'package:rythem_rider/domain/db_functions/splash/splash_functions.dart';
import 'package:rythem_rider/domain/model/all_songs/model.dart';
import 'package:rythem_rider/domain/model/fav/fav_mode.dart';
import 'package:rythem_rider/domain/model/mostply_played/mosltly_played_model.dart';
import 'package:rythem_rider/domain/model/playlist/playlist_model.dart';
import 'package:rythem_rider/domain/model/recently_played/recently_model.dart';
import 'package:rythem_rider/presentation/home/screen_home.dart';
import 'package:rythem_rider/presentation/splash/screen_splash.dart';

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

 

  justAudioPlayerObjectNew.stop();
  miniPlayerActive.value = false;


  context.read<NowPlayingBloc>().add(ClearNowPlayingCall());

  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    builder: (context) {
      return const ScreenSplash();
    },
  ), (route) => false);
}
