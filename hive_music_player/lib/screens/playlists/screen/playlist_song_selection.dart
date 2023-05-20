import 'package:flutter/material.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';

import 'package:hive_music_player/screens/playlists/widgets/add_song_tile.dart';

class ScreenPlaylistSongSelection extends StatelessWidget {
  ScreenPlaylistSongSelection({super.key, required this.playlistIndex});

  final int playlistIndex;

  final box = MusicBox.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: mainColor,
          appBar: AppBar(
            backgroundColor: mainColor,
            title: const Text('Add Song To Playlist'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  final list = box.values.toList();
                  return PlaylistSongSelectTile(
                    allSongs: list,
                    indexSong: index,
                    playlistIndex: playlistIndex,
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: box.values.length),
          )),
    );
  }
}
