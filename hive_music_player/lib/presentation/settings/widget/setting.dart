import 'package:flutter/material.dart';

class SettingTileCustom extends StatelessWidget {
  final String name;
  final IconData icon;

  const SettingTileCustom({
    super.key,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 60,
        width: double.infinity,
        color: Colors.transparent.withOpacity(0.3),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  name,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
