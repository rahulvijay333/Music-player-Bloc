import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/playlist/playlist_bloc.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
import 'package:hive_music_player/domain/model/playlist/playlist_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistSongSelectTile extends StatelessWidget {
  const PlaylistSongSelectTile({
    super.key,
    required this.playlistIndex,
    required this.allSongs,
    required this.indexSong,
  });

  final int indexSong;
  final int playlistIndex;
  final List<AudioModel> allSongs;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
          color: Colors.transparent.withOpacity(0.3),
          height: 80,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              QueryArtworkWidget(
                  artworkWidth: 50,
                  artworkHeight: 50,
                  artworkBorder: BorderRadius.circular(10),
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/song_tile_empty.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  id: allSongs[indexSong].id!,
                  type: ArtworkType.AUDIO),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allSongs[indexSong].title!,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      allSongs[indexSong].artist!,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 14.0,
                          //color: Colors.grey[600],
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: BlocBuilder<PlaylistBloc, PlaylistState>(
                  builder: (context, state) {
                    if (state.playlists[playlistIndex].playlistSongs
                        .where(
                            (element) => element.id == allSongs[indexSong].id)
                        .isEmpty) {
                      return const Icon(
                        Icons.add,
                        color: Colors.white,
                      );
                    } else {
                      return const Icon(
                        Icons.close,
                        color: Colors.white,
                      );
                    }
                  },
                ),
                onPressed: () {
                
                  //---------------------------------------------bloc add to playlist

                  BlocProvider.of<PlaylistBloc>(context)
                      .add(AddToPlaylist(playlistIndex, indexSong,context));
                },
              ),
            ],
          )),
    );
  }
}
