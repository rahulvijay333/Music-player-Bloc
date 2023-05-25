import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/playlist/playlist_bloc.dart';
import 'package:hive_music_player/domain/model/playlist_con/concatenation.dart';

class PlaylistCard extends StatefulWidget {
  final String playlistName;
  final int songCount;
  final int index;

  const PlaylistCard({
    super.key,
    required this.playlistName,
    required this.songCount,
    required this.index,
  });

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  final _editPlaylistController = TextEditingController();

  @override
  void initState() {
    _editPlaylistController.text = widget.playlistName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent.withOpacity(0.2),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            // Thumbnail
            Container(
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[300],
              ),
              child: const Icon(
                Icons.playlist_play_outlined,
                size: 60,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Playlist name
                  Text(widget.playlistName,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 8),
                  // Song count
                  Text('${widget.songCount} songs',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Delete, edit, and play buttons
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //-----------------------------------------delete playlist function

                    deleteDialogue(context, widget.index);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //----------------------------------------edit playlist  //snack bar implemention left <<<<---------------

                    editPlayListDialoge(
                      index: widget.index,
                      playlistName: widget.playlistName,
                      ctx: context,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  editPlayListDialoge({
    required int index,
    required String playlistName,
    required BuildContext ctx,
  }) {
    bool checkPlalistNameExist = false;
    bool checktextFieldValue = false;
    final oldPlaylistName = playlistName;
    showDialog(
      context: ctx,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent.withOpacity(0.9),
              title: const Text(
                'Rename Playlist',
                style: TextStyle(color: Colors.white),
              ),
              content: SizedBox(
                width: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
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
                          filled: true),
                      controller: _editPlaylistController,
                    ),
                    Visibility(
                      visible: checkPlalistNameExist,
                      child: Container(
                        child: const Text(
                          'Name already exists',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: checktextFieldValue,
                      child: Container(
                        child: const Text(
                          'Enter playlist name ',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      //---------------------------------save
                      if (_editPlaylistController.text == oldPlaylistName) {
                        //editPlayList(name: oldPlaylistName, index: index);
                        BlocProvider.of<PlaylistBloc>(context).add(
                            EditPlaylist(name: oldPlaylistName, index: index));

                        Navigator.of(context).pop();
                      } else if (checkPlaylistName(
                          _editPlaylistController.text)) {
                        setState(() {
                          checkPlalistNameExist = true;
                          checktextFieldValue = false;
                        });
                      } else if (_editPlaylistController.text.isEmpty) {
                        setState(() {
                          checktextFieldValue = true;
                          checkPlalistNameExist = false;
                        });
                      } else {
                        // editPlayList(
                        //     name: _editPlaylistController.text, index: index);

                        //------------------------------------------------------------------------playlist edit bloc
                        BlocProvider.of<PlaylistBloc>(context).add(EditPlaylist(
                            name: _editPlaylistController.text, index: index));
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Save',
                        style: TextStyle(color: Colors.white))),
                TextButton(
                    onPressed: () {
                      //---------------------------------cancel

                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)))
              ],
            );
          },
        );
      },
    );
  }
}

deleteDialogue(BuildContext context, int index) {
  showDialog(
    context: context,
    builder: (ctx1) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: const Text('Warning', style: TextStyle(color: Colors.white)),
        content: const Text('Do you want to delete playlist ?',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () {
                //deletePlaylist(index);

                BlocProvider.of<PlaylistBloc>(context)
                    .add(DeletePlaylist(index));
                Navigator.of(context).pop();
              },
              child: const Text('Yes', style: TextStyle(color: Colors.white))),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ))
        ],
      );
    },
  );
}
