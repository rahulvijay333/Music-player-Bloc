import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ImageTilePlayingCustom extends StatelessWidget {
  const ImageTilePlayingCustom({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: QueryArtworkWidget(
          artworkWidth: size.width * 0.4,
          //artworkHeight: 50,
          artworkBorder: BorderRadius.circular(10),
          nullArtworkWidget: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/song_tile_empty.png',
              width: 350,
              //height: 50,
              fit: BoxFit.cover,
            ),
          ),
          id: id,
          type: ArtworkType.AUDIO),
    );
  }
}
