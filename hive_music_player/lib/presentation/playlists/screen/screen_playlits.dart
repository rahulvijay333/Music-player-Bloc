import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rythem_rider/application/now_playing/bloc/now_playing_bloc.dart';
import 'package:rythem_rider/application/playlist/playlist_bloc.dart';
import 'package:rythem_rider/common/common.dart';
import 'package:rythem_rider/common/widgets/app_bar_custom.dart';
import 'package:rythem_rider/domain/model/playlist_con/concatenation.dart';
import 'package:rythem_rider/presentation/all%20songs/widgets/show_playlist_dialoge.dart';
import 'package:rythem_rider/presentation/home/screen_home.dart';
import 'package:rythem_rider/presentation/now_playing/screen_now_playing.dart';
import 'package:rythem_rider/presentation/playlists/screen/playlist.dart';
import 'package:rythem_rider/presentation/playlists/widgets/play_list_card.dart';

//-------------------------------------------------------list of playlist screen

class ScreenPlaylists extends StatelessWidget {
  ScreenPlaylists({super.key});

  final playlistNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    BlocProvider.of<PlaylistBloc>(context).add(GetAllPlaylist());
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
                      heading: 'Playlist',
                      twoItems: true,
                      widgetLeft: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,)),
                      widgetRight: IconButton(
                          onPressed: () {
                            createPlayListDialoge(context);
                          },
                          icon: const Icon(
                            Icons.playlist_add,
                            color: Colors.white,
                          )),
                    ),
                    Expanded(
                      child: BlocBuilder<PlaylistBloc, PlaylistState>(
                        builder: (context, state) {
                          if (state.playlists.isEmpty) {
                            return const Center(
                              child: Text(
                                'No  Playlist',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          return ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (ctx1) {
                                          return ScreenPlaylist(
                                              playlistIndex: index,
                                              playlistName: state
                                                  .playlists[index]
                                                  .playlistName!,
                                              playlistSongLists: state
                                                  .playlists[index]
                                                  .playlistSongs);
                                        },
                                      ));
                                    },
                                    child: PlaylistCard(
                                        index: index,
                                        playlistName: state
                                            .playlists[index].playlistName!,
                                        songCount: state.playlists[index]
                                            .playlistSongs.length));
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: state.playlists.length);
                        },
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
                                bottom: 0,
                                left: 0,
                                right: 0,
                                top: showingMiniPlayer.value ? null : 0,
                                child: BlocBuilder<NowPlayingBloc,
                                    NowPlayingState>(
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
      ),
    );
  }

  createNewPlayListDialoge(BuildContext context) {
    bool errorCheck = false;
    bool errorValueEmpty = false;

    return showDialog(
      context: context,
      builder: (ctx1) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent.withOpacity(0.9),
              title: const Text(
                'Create New Playlist',
                style: TextStyle(color: Colors.white),
              ),
              content: Container(
                // width: 300,
                width: MediaQuery.of(context).size.width * 0.6,
                height: 100,
                child: Column(
                  children: [
                    TextFormField(
                      controller: playlistNameController,
                      decoration: InputDecoration(
                        hintText: 'Playlist Name',
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            )),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            )),
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: errorCheck,
                      child: Expanded(
                        child: Container(
                          child: const Text(
                            'Playlist name already exist',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: errorValueEmpty,
                        child: Container(
                          child: const Text(
                            'Playlist name not entered',
                            style: TextStyle(color: Colors.red),
                          ),
                        ))
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      //-----------------------------playlist create
                      //condition check

                      if (checkPlaylistName(playlistNameController.text)) {
                        setState(() {
                          errorCheck = true;
                          errorValueEmpty = false;
                        });

                        playlistNameController.clear();
                      } else if (playlistNameController.text.isEmpty) {
                        setState(() {
                          errorValueEmpty = true;
                          errorCheck = false;
                        });
                        playlistNameController.clear();
                      } else {
                        //------------------------------------------------------------------bloc implementation
                        BlocProvider.of<PlaylistBloc>(context)
                            .add(CreatePlaylist(playlistNameController.text));

                        playlistNameController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            );
          },
        );
      },
    );
  }
}
