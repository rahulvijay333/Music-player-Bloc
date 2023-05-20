import 'package:flutter/material.dart';
import 'package:hive_music_player/hive/db_functions/favourites/fav_function.dart';
import 'package:hive_music_player/hive/db_functions/mostly_played/moslty_played_function.dart';
import 'package:hive_music_player/hive/db_functions/playlist/playlist_functions.dart';
import 'package:hive_music_player/hive/db_functions/recentlyPlayed/recently_function.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/fav/fav_mode.dart';
import 'package:hive_music_player/hive/model/recently_played/recently_model.dart';
import 'package:hive_music_player/screens/now_playing/screen_now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistSongsTileCustom extends StatefulWidget {
  const PlaylistSongsTileCustom(
      {super.key,
      required this.songlist,
      required this.index,
      required this.playlistindex});

  final List<AudioModel> songlist;
  final int index;
  final int playlistindex;

  @override
  State<PlaylistSongsTileCustom> createState() =>
      _PlaylistSongsTileCustomState();
}

class _PlaylistSongsTileCustomState extends State<PlaylistSongsTileCustom> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.transparent.withOpacity(0.3),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            QueryArtworkWidget(
                artworkWidth: 50,
                artworkHeight: 50,
                artworkBorder: BorderRadius.circular(20),
                nullArtworkWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/song_tile_empty.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                id: widget.songlist[widget.index].id!,
                type: ArtworkType.AUDIO),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  //----------------------------------------------click to play
                  final recentSong = RecentlyPlayed(
                      widget.songlist[widget.index].title,
                      widget.songlist[widget.index].artist,
                      widget.songlist[widget.index].id,
                      widget.songlist[widget.index].uri,
                      widget.songlist[widget.index].duration);
                  updateRecentPlay(recentSong);
                  updateMostlyPlayedDB(widget.songlist[widget.index]);

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return ScreenNowPlaying(
                        songs: widget.songlist,
                        index: widget.index,
                      );
                    },
                  ));
                  //----------------------------------------------------update mini platyer list

                  globalMiniList.value.clear();
                  globalMiniList.value.addAll(widget.songlist);
                  globalMiniList.notifyListeners();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.songlist[widget.index].title!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    Text(
                      widget.songlist[widget.index].artist!,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //--------------------------------------------------favourite add button section
            IconButton(
              icon: ValueListenableBuilder(
                valueListenable: favNotifier,
                builder: (context, favlist, child) {
                  //here id and song list available.
                  Favourites currentSong = Favourites(
                      title: widget.songlist[widget.index].title,
                      artist: widget.songlist[widget.index].artist,
                      id: widget.songlist[widget.index].id,
                      uri: widget.songlist[widget.index].uri,
                      duration: widget.songlist[widget.index].duration);

                  if (favlist
                      .where((fav) => fav.id == currentSong.id)
                      .isEmpty) {
                    return const Icon(Icons.favorite, color: Colors.white);
                  } else {
                    return const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    );
                  }
                },
              ),
              onPressed: () {
                //------------------------get index of song from all songs db and compare with playlist
                final allbox = MusicBox.getInstance();
                final allSongsList = allbox.values.toList();
                int getIndexSong = allSongsList.indexWhere((element) =>
                    element.id == widget.songlist[widget.index].id);
                //---------------------------------------------------------------------
                if (checkFavouriteStatus(getIndexSong)) {
                  addToFavouritesDB(getIndexSong);

                  //snackbar
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Song added to Favourites',
                      )));
                } else if (!checkFavouriteStatus(getIndexSong)) {
                  //remove function
                  removeFromFavouritesDb(getIndexSong);

                  //snackbar
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Song Removed From Favourites',
                      )));
                }
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.remove,
                color: Colors.white,
              ),
              onPressed: () {
                deleteSongFromPlaylist(
                    playListIndex: widget.playlistindex,
                    songIndex: widget.index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
