import 'package:flutter/material.dart';
import 'package:hive_music_player/hive/db_functions/favourites/fav_function.dart';
import 'package:hive_music_player/hive/db_functions/mostly_played/moslty_played_function.dart';
import 'package:hive_music_player/hive/db_functions/recentlyPlayed/recently_function.dart';

import 'package:hive_music_player/hive/model/fav/fav_mode.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/recently_played/recently_model.dart';

import 'package:hive_music_player/screens/all%20songs/widgets/show_playlist_dialoge.dart';

import 'package:hive_music_player/screens/now_playing/screen_now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AllSongTileWidget extends StatelessWidget {
  const AllSongTileWidget(
      {super.key, required this.songlist, required this.index});

  final List<AudioModel> songlist;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.transparent.withOpacity(0.3),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            //--------------------------------------song image here
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
                id: songlist[index].id!,
                type: ArtworkType.AUDIO),
            const SizedBox(width: 10),

            //----------------------------------------song name and artist
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final recentSong = RecentlyPlayed(
                      songlist[index].title,
                      songlist[index].artist,
                      songlist[index].id,
                      songlist[index].uri,
                      songlist[index].duration);
                  updateRecentPlay(recentSong);
                  updateMostlyPlayedDB(songlist[index]);

                  globalMiniList.value.clear();
                  globalMiniList.value.addAll(songlist);
                  globalMiniList.notifyListeners();

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return ScreenNowPlaying(
                        index: index,
                        songs: songlist,
                      );
                    },
                  ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      songlist[index].title!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    Text(
                      songlist[index].artist!,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //-----------------------------------------------favourite button status
            IconButton(
              icon: ValueListenableBuilder(
                valueListenable: favNotifier,
                builder: (context, favlist, child) {
                  //here id and song list available.
                  Favourites currentSong = Favourites(
                      title: songlist[index].title,
                      artist: songlist[index].artist,
                      id: songlist[index].id,
                      uri: songlist[index].uri,
                      duration: songlist[index].duration);

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
                // ---------------------------------------------Add to favorites
                if (checkFavouriteStatus(index)) {
                  addToFavouritesDB(index);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Song added to Favourites',
                      )));
                } else if (!checkFavouriteStatus(index)) {
                  //-----------------------------------------------remove from fav
                  removeFromFavouritesDb(index);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      content: Text('Song removed from Favourites')));
                }
              },
            ),
            //---------------------------------playlist add button
            IconButton(
              icon: const Icon(
                Icons.playlist_add,
                color: Colors.white,
              ),
              onPressed: () {
                // Add to playlist
                showPlaylistDialog(context, index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
