import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rythem_rider/application/now_playing/bloc/now_playing_bloc.dart';

import 'package:rythem_rider/common/common.dart';
import 'package:rythem_rider/domain/db_functions/splash/splash_functions.dart';
import 'package:rythem_rider/domain/model/all_songs/model.dart';

import 'package:rythem_rider/presentation/home/screen_home.dart';
import 'package:rythem_rider/presentation/permission_missing/permission_error_Screen.dart';
import 'package:rythem_rider/presentation/splash/logo/logo.dart';

bool retryS = false;

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  bool _hasPermission = false;

  Future<bool> checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await audioquery.checkAndRequest(
      retryRequest: retry,
    );

    if (_hasPermission) {
      final List<AudioModel> songslist = [];
      querySongs = await audioquery.querySongs();
      await box.clear();
      for (var song in querySongs) {
        final songFromDevice = AudioModel(
            title: song.title,
            artist: song.artist,
            id: song.id,
            uri: song.uri,
            duration: song.duration);

        if (!songslist.contains(songFromDevice)) {
          songslist.add(songFromDevice);
          await box.add(AudioModel(
              title: song.title,
              artist: song.artist,
              id: song.id,
              uri: song.uri,
              duration: song.duration));
        }
      }
      await Future.delayed(const Duration(seconds: 2));

      gotohomePage();
      return true;
    } else {
      gotoPermissionErrorPage();
      return false;
    }
  }

  @override
  void initState() {
    checkAndRequestPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainColor,
        body: Center(child: FadeInContainer()),
      ),
    );
  }

  void gotohomePage() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (ctx) {
        return const ScreenHome();
      },
    ));
  }

  void gotoPermissionErrorPage() async {
    // await Future.delayed(const Duration(seconds: 1));

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (ctx) {
        return const ScreenPermissionError();
      },
    ));
  }
}
