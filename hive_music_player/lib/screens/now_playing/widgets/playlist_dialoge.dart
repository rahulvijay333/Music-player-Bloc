import 'package:flutter/material.dart';
import 'package:hive_music_player/hive/db_functions/playlist/playlist_functions.dart';
import 'package:hive_music_player/hive/model/playlist/playlist_model.dart';



showNowPlayingPlaylistDialog(BuildContext context, int songIndex) {
  final box = PlaylistBox.getInstance();
  final playlist_list = box.values.toList();

  showDialog(
    context: context,
    builder: (ctx1) {
      return AlertDialog(
        elevation: 20,
        backgroundColor: Colors.transparent.withOpacity(1),
        title: const Text('Add to Playlist',
            style: TextStyle(color: Colors.white)),
        content: playlist_list.isNotEmpty
            ? SizedBox(
                width: 300,
                //height: 200,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: playlist_list.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        //--------------------------------playlist add function
                        addToPlaylist(
                            playlistIndex: index,
                            songIndex: songIndex,
                            context: context);

                        Navigator.of(context).pop();
                      },
                      child: Text(playlist_list[index].playlistName!,
                          style: const TextStyle(color: Colors.white)),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    );
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
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'cancel',
                style: TextStyle(color: Colors.white),
              ))
        ],
      );
    },
  );
}
