import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/application/playlist/playlist_bloc.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/hive/db_functions/playlist/playlist_functions.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/playlist/playlist_model.dart';
import 'package:hive_music_player/hive/model/playlist_con/concatenation.dart';
import 'package:hive_music_player/screens/home/screen_home.dart';
import 'package:hive_music_player/screens/miniPlayer/mini_player.dart';
import 'package:hive_music_player/screens/playlists/screen/playlist.dart';
import 'package:hive_music_player/screens/playlists/widgets/play_list_card.dart';

class ScreenPlaylists extends StatelessWidget {
  ScreenPlaylists({super.key});

  // final playlistbx = PlaylistBox.getInstance();

  final playlistNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PlaylistBloc>(context).add(GetAllPlaylist());
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
            title: const Text(
              'Playlists',
            ),
            backgroundColor: mainColor,
            centerTitle: true,
            actions: [
              //---------------------------------------------------------temperoy cancelled
              IconButton(
                  onPressed: () {
                    createNewPlayListDialoge(context);
                  },
                  icon: const Icon(Icons.playlist_add))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
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
                           
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx1) {
                                return ScreenPlaylist(
                                    playlistIndex: index,
                                    playlistName:
                                        state.playlists[index].playlistName!,
                                    playlistSongLists:
                                        state.playlists[index].playlistSongs);
                              },
                            ));
                          },
                          child: PlaylistCard(
                              index: index,
                              playlistName:
                                  state.playlists[index].playlistName!,
                              songCount:
                                  state.playlists[index].playlistSongs.length));
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: state.playlists.length);
              },
            ),
          )),
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
