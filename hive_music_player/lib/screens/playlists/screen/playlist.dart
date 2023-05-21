import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/application/playlist/playlist_bloc.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/hive/db_functions/playlist/playlist_functions.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/playlist/playlist_model.dart';
import 'package:hive_music_player/screens/home/screen_home.dart';
import 'package:hive_music_player/screens/miniPlayer/mini_player.dart';
import 'package:hive_music_player/screens/playlists/screen/playlist_song_selection.dart';
import 'package:hive_music_player/screens/playlists/widgets/playlist_tile.dart';

class ScreenPlaylist extends StatelessWidget {
  ScreenPlaylist(
      {super.key,
      required this.playlistName,
      required this.playlistSongLists,
      required this.playlistIndex});

  final String playlistName;
  final List<AudioModel> playlistSongLists;
  final int playlistIndex;

  // final playbox = PlaylistBox.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: miniPlayerStatusNotifier,
              builder: (context, value, child) {
                if (value == false) {
                  return const SizedBox();
                } else {
                  return const MiniPlayer();
                }
              },
            ),
            backgroundColor: mainColor,
            appBar: AppBar(
              backgroundColor: mainColor,
              title: Text(playlistName),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          //pass playlist index ,
                          return ScreenPlaylistSongSelection(
                            playlistIndex: playlistIndex,
                          );
                        },
                      ));
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<PlaylistBloc, PlaylistState>(
                builder: (context, state) {
                  if (state.playlists[playlistIndex].playlistSongs.isEmpty) {
                    return const Center(
                      child: Text('No Songs',style: TextStyle(color: Colors.white),),
                    );
                  } else {
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return PlaylistSongsTileCustom(
                              playlistindex: playlistIndex,
                              songlist:
                                  state.playlists[playlistIndex].playlistSongs,
                              index: index);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: playlistSongLists.length);
                  }
                },
              ),
            )));
  }
}
