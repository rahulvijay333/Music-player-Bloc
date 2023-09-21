import 'package:flutter/material.dart';
import 'package:rythem_rider/common/common.dart';

aboutSection(BuildContext context) {
  showDialog(
      barrierColor: Colors.transparent.withOpacity(0.8),
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: mainColor.withOpacity(0.8),
            title: const Text(
              'About Us',
              style: TextStyle(color: Colors.white),
            ),
            content: Container(
              child: const Text(
                '''RythemRider is an offline music player that lets you take your music anywhere you go, without needing an internet connection. With RythemRider, you can easily manage your music favourites, create playlists, and enjoy your favorite songs on-the-go.

Our app is designed with simplicity in mind, making it easy for you to find and play your favorite songs with just a few taps. Whether you're on a road trip, working out at the gym, or just relaxing at home, RythemRider has got you covered.

We believe that music is a universal language that brings people together, and we're passionate about creating a seamless music experience for our users. We're constantly improving our app and adding new features to make your music experience even better.

Download RythemRider today and start enjoying your favorite songs offline!''',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Dismiss',
                    style: TextStyle(color: Colors.white),
                  )),
            ]);
      });
}
