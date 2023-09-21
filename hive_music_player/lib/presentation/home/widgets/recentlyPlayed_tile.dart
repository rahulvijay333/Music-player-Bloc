import 'package:flutter/material.dart';
import 'package:rythem_rider/domain/model/all_songs/model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentlyPlayedCustomTile extends StatelessWidget {
  const RecentlyPlayedCustomTile({
    super.key,
    required this.songName,
    required this.artistName,
    required this.list,
    required this.index,
  });

  final String songName;
  final String artistName;
  final int index;
  final List<AudioModel> list;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        QueryArtworkWidget(
            artworkWidth: 350,
            artworkHeight: 80,
            artworkBorder: BorderRadius.circular(5),
            nullArtworkWidget: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                'assets/song_tile_empty.png',
                width: 350,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            id: list[index].id!,
            type: ArtworkType.AUDIO),
        Container(
          //width: 350,
          width: double.infinity,
          height: 35,
          decoration: const BoxDecoration(
            // color: Colors.amber,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  songName,
                  maxLines: 1,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(),
                Text(
                  artistName,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
