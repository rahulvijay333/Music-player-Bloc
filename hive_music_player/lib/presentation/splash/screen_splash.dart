import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rythem_rider/application/now_playing/bloc/now_playing_bloc.dart';

import 'package:rythem_rider/common/common.dart';
import 'package:rythem_rider/domain/db_functions/splash/splash_functions.dart';

import 'package:rythem_rider/presentation/home/screen_home.dart';
import 'package:rythem_rider/presentation/splash/logo/logo.dart';

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
