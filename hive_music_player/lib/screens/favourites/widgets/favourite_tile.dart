import 'package:flutter/material.dart';

import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/hive/db_functions/favourites/fav_function.dart';
import 'package:hive_music_player/hive/db_functions/mostly_played/moslty_played_function.dart';
import 'package:hive_music_player/hive/db_functions/recentlyPlayed/recently_function.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/recently_played/recently_model.dart';

import 'package:hive_music_player/screens/now_playing/screen_now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavouriteTileCustom extends StatefulWidget {
  const FavouriteTileCustom(
      {super.key,
      required this.songName,
      required this.index,
      required this.id,
      required this.size});

  final String songName;
  final int index;
  final int id;
  final Size size;

  @override
  State<FavouriteTileCustom> createState() => _FavouriteTileCustomState();
}

class _FavouriteTileCustomState extends State<FavouriteTileCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * 0.1,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0), mainColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.2),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //-------------------------------------------------------image
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
                id: widget.id,
                type: ArtworkType.AUDIO),
            const SizedBox(
              width: 10,
            ),

            //-----------------------------------------------------song name
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  //-----------------------------------------------convertion into audiomodel music collections concatenation purpose
                  final favlist = favouritesDbBox.values.toList();

                  List<AudioModel> favCollections =
                      convertToAudioModel(favlist);

                  final recentSong = RecentlyPlayed(
                      favCollections[widget.index].title,
                      favCollections[widget.index].artist,
                      favCollections[widget.index].id,
                      favCollections[widget.index].uri,
                      favCollections[widget.index].duration);
                  updateRecentPlay(recentSong);
                  updateMostlyPlayedDB(favCollections[widget.index]);

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return ScreenNowPlaying(
                        songs: favCollections,
                        index: widget.index,
                      );
                    },
                  ));

                  //update mini player list
                  globalMiniList.value.clear();
                  globalMiniList.value.addAll(favCollections);
                  globalMiniList.notifyListeners();
                },
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.songName,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                //--------------------------------------------- delete function  to remove song
                deleteFromFavouritesDb(widget.id, context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Song removed from favourites')));
              },
              icon: ValueListenableBuilder(
                valueListenable: favNotifier,
                builder: (context, favlist, child) {
                  if (favlist.where((fav) => fav.id == widget.id).isEmpty) {
                    return const Icon(Icons.favorite, color: Colors.white);
                  } else {
                    return const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
