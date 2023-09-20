import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_music_player/application/now_playing/bloc/now_playing_bloc.dart';
import 'package:hive_music_player/application/playlist/playlist_bloc.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/common/widgets/app_bar_custom.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
import 'package:hive_music_player/presentation/home/screen_home.dart';
import 'package:hive_music_player/presentation/now_playing/screen_now_playing.dart';
import 'package:hive_music_player/presentation/playlists/screen/playlist_song_selection.dart';
import 'package:hive_music_player/presentation/playlists/widgets/playlist_tile.dart';

//add appbar
class ScreenPlaylist extends StatelessWidget {
  ScreenPlaylist(
      {super.key,
      required this.playlistName,
      required this.playlistSongLists,
      required this.playlistIndex});

  final String playlistName;
  final List<AudioModel> playlistSongLists;
  final int playlistIndex;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        if (showingMiniPlayer.value == false) {
          showingMiniPlayer.value = true;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          backgroundColor: mainColor,
          body: Stack(
            children: [
              Column(
                children: [
                  CustomAppBar(
                    size: size,
                    heading: playlistName,
                    twoItems: true,
                    widgetRight: IconButton(
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
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
                    widgetLeft: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<PlaylistBloc, PlaylistState>(
                        builder: (context, state) {
                          log(state
                              .playlists[playlistIndex].playlistSongs.length
                              .toString());
                          if (state
                              .playlists[playlistIndex].playlistSongs.isEmpty) {
                            return const Center(
                              child: Text(
                                'No Songs',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else {
                            return Scrollbar(
                              controller: scrollController,
                              child: ListView.separated(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: PlaylistSongsTileCustom(
                                          playlistindex: playlistIndex,
                                          songlist: state
                                              .playlists[playlistIndex]
                                              .playlistSongs,
                                          index: index),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 5,
                                    );
                                  },
                                  itemCount: playlistSongLists.length),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: miniPlayerActive,
                builder: (context, isActive, child) {
                  return Visibility(
                      visible: isActive,
                      child: ValueListenableBuilder(
                        valueListenable: showingMiniPlayer,
                        builder: (context, value, child) {
                          return Positioned(
                              bottom: 0, // Adjust the position as needed
                              left: 0,
                              right: 0,
                              top: showingMiniPlayer.value ? null : 0,
                              child:
                                  BlocBuilder<NowPlayingBloc, NowPlayingState>(
                                builder: (context, state) {
                                  return  ScreenNowPlaying(songs: state.songsList!,);
                                },
                              ));
                        },
                      ));
                },
              )
            ],
          )),
    ));
  }
}
