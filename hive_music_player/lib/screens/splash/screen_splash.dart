import 'package:flutter/material.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/hive/db_functions/splash/splash_functions.dart';

import 'package:hive_music_player/screens/home/screen_home.dart';
import 'package:hive_music_player/screens/splash/logo/logo.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    getStoragePermissionInitialMethod();

    super.initState();

    gotohomePage();
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
    await Future.delayed(const Duration(seconds: 5));

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (ctx) {
        return const ScreenHome();
      },
    ));
  }
}
