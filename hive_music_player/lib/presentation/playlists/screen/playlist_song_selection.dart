import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/all%20songs/all_songs_bloc.dart';
import 'package:hive_music_player/common/common.dart';

import 'package:hive_music_player/presentation/playlists/widgets/add_song_tile.dart';

class ScreenPlaylistSongSelection extends StatelessWidget {
  const ScreenPlaylistSongSelection({super.key, required this.playlistIndex});

  final int playlistIndex;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AllSongsBloc>(context).add(GetAllSongs());
    return SafeArea(
      child: Scaffold(
          backgroundColor: mainColor,
          appBar: AppBar(
            backgroundColor: mainColor,
            title: const Text('Add Song To Playlist'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: BlocBuilder<AllSongsBloc, AllSongsState>(
              builder: (context, state) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return PlaylistSongSelectTile(
                        allSongs: state.allsongs,
                        indexSong: index,
                        playlistIndex: playlistIndex,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: state.allsongs.length);
              },
            ),
          )),
    );
  }
}