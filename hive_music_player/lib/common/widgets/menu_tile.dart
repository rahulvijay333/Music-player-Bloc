import 'package:flutter/material.dart';

import 'package:rythem_rider/common/common.dart';

class MenuTileWidget extends StatelessWidget {
  const MenuTileWidget({
    super.key,
    required this.categoryName,
    required this.size,
  });
  final String categoryName;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: size.height*0.35*0.45,
          //width: 185,
          width: size.width * 0.45,
          //height: double.infinity,
          //width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.white.withOpacity(0.2),
              mainColor.withOpacity(0.5),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Center(
            child: Text(
              categoryName,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}
