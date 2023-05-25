import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/playlist/playlist_bloc.dart';
import 'package:hive_music_player/domain/model/playlist/playlist_model.dart';

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
        content: BlocBuilder<PlaylistBloc, PlaylistState>(
          builder: (context, state) {
            if (state.playlists.isEmpty) {
              return const Center(
                child: Text('No Playlists'),
              );
            }

            return SizedBox(
              width: 300,
              //height: 200,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.playlists.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      //--------------------------------playlist bloc add function
                   
                      BlocProvider.of<PlaylistBloc>(context)
                          .add(AddToPlaylist(index, songIndex, context));

                      Navigator.of(context).pop();
                    },
                    child: Text(state.playlists[index].playlistName!,
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
            );
          },
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
