import 'dart:async';

import 'package:flutter/material.dart';

class FadeInContainer extends StatefulWidget {
  @override
  _FadeInContainerState createState() => _FadeInContainerState();
}

class _FadeInContainerState extends State<FadeInContainer> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Set a timer to toggle the visibility of the container widget after 2 seconds
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: _visible
          ? 1.0
          : 0.0, // Set opacity to 1.0 if _visible is true, 0.0 otherwise
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/logo.png'))),
      ),
    );
  }
}
