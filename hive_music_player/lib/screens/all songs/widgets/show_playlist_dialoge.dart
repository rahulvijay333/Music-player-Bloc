import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/playlist/playlist_bloc.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/hive/model/playlist/playlist_model.dart';
import 'package:hive_music_player/hive/model/playlist_con/concatenation.dart';

final createPlaylistController = TextEditingController();

showPlaylistDialog(BuildContext context, int songIndex) {
  final box = PlaylistBox.getInstance();
  final playlistlist = box.values.toList();
  String selected = '';
//-------------------------------------------------------------add to playlist
  showDialog(
    useSafeArea: true,
    barrierColor: mainColor.withOpacity(0.5),
    barrierDismissible: false,
    context: context,
    builder: (ctx1) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //shadowColor: Colors.white,
            elevation: 20,
            backgroundColor: Colors.transparent.withOpacity(1),
            title: const Text('Add to Playlist',
                style: TextStyle(color: Colors.white)),
            content: playlistlist.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.white)),
                    width: 180,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: playlistlist.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            //--------------------------------playlist add function
                            // addToPlaylist(
                            //     playlistIndex: index,
                            //     songIndex: songIndex,
                            //     context: context);

                            Navigator.of(context).pop();
                          },
                          child: RadioListTile(
                            tileColor: Colors.white,
                            title: Text(
                              playlistlist[index].playlistName!,
                              style: const TextStyle(color: Colors.black),
                            ),
                            value: playlistlist[index].playlistName,
                            groupValue: selected,
                            onChanged: (value) async {
                              setState(() {
                                selected = value!;
                              });
                              // addToPlaylist(
                              //     playlistIndex: index,
                              //     songIndex: songIndex,
                              //     context: context);

                             BlocProvider.of<PlaylistBloc>(context).add(AddToPlaylist(index, songIndex, context));

                              await Future.delayed(const Duration(seconds: 1));
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox();
                      },
                    ),
                  )
                : const SizedBox(
                    width: 300,
                    height: 100,
                    child: Center(
                      child: Center(
                          child: Text(
                        'No playlist',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
            actions: [
              //-----------------------------------------create
              TextButton(
                  onPressed: () async {
                    await createPlayListDialoge(ctx1);
                    Navigator.of(context).pop();
                    showPlaylistDialog(context, songIndex);
                  },
                  child: const Text(
                    'Create New ',
                    style: TextStyle(color: Colors.white),
                  )),

              //------------------------------------------cancel
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          );
        },
      );
    },
  );
}

//-------------------------------------------------------------create new
createPlayListDialoge(BuildContext context) {
  bool errorCheck = false;
  bool errorNameCheck = false;
  return showDialog(
    barrierColor: mainColor.withOpacity(0.8),
    context: context,
    builder: (ctx1) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            //shadowColor: Colors.white.withOpacity(0.5),
            //surfaceTintColor: Colors.amber,
            backgroundColor: Colors.black,
            title: const Text(
              'Create New Playlist',
              style: TextStyle(color: Colors.white),
            ),
            content: SizedBox(
              height: 100,
              child: Column(children: [
                TextFormField(
                  controller: createPlaylistController,
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
                  child: Container(
                    child: const Text(
                      'Playlist name already exist',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                Visibility(
                  visible: errorNameCheck,
                  child: Container(
                    child: const Text(
                      'No name entered',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    //-----------------------------playlist create
                    if (checkPlaylistName(createPlaylistController.text)) {
                      setState(() {
                        errorCheck = true;
                        errorNameCheck = false;
                      });
                    } else if (createPlaylistController.text.isEmpty) {
                      setState(() {
                        errorCheck = false;
                        errorNameCheck = true;
                      });
                    } else {
                      // createPlaylist(createPlaylistController.text);

                      BlocProvider.of<PlaylistBloc>(context)
                          .add(CreatePlaylist(createPlaylistController.text));

                      Navigator.of(context).pop();
                      createPlaylistController.clear();
                    }

                    // Navigator.of(context).pop();
                    createPlaylistController.clear();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    createPlaylistController.clear();
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
