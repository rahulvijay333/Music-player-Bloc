import 'package:flutter/material.dart';
import 'package:rythem_rider/common/common.dart';
import 'package:rythem_rider/presentation/splash/screen_splash.dart';

class ScreenPermissionError extends StatelessWidget {
  const ScreenPermissionError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Required Storage permission to access songs',
              style: TextStyle(color: Colors.white),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) {
                      return const ScreenSplash();
                    },
                  ), (route) => false);
                },
                child: const Text('Reload'))
          ],
        ),
      ),
    );
  }
}
