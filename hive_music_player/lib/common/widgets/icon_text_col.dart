import 'package:flutter/material.dart';

class IconTextColWidget extends StatelessWidget {
  const IconTextColWidget({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon),
          padding: const EdgeInsets.all(0),
          alignment: Alignment.bottomCenter,
          color: Colors.white,
        ),
        Text(text)
      ],
    );
  }
}
