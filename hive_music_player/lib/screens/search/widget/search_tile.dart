import 'package:flutter/material.dart';
import 'package:hive_music_player/hive/db_functions/favourites/fav_function.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/fav/fav_mode.dart';
import 'package:hive_music_player/screens/now_playing/screen_now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchTileWidget extends StatefulWidget {
  const SearchTileWidget({
    super.key,
    required this.songName,
    required this.artistName,
    required this.audioList,
    required this.index,
  });

  final String songName;
  final String artistName;
  final List<AudioModel> audioList;
  final int index;

  @override
  State<SearchTileWidget> createState() => _SearchTileWidgetState();
}

class _SearchTileWidgetState extends State<SearchTileWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: 60,
        color: Colors.transparent.withOpacity(0.3),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
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
                id: widget.audioList[widget.index].id!,
                type: ArtworkType.AUDIO),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                //--------------------------------------------------now playing
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return ScreenNowPlaying(
                      songs: widget.audioList,
                      index: widget.index,
                    );
                  },
                ));

                globalMiniList.value.clear();
                globalMiniList.value.addAll(widget.audioList);
                globalMiniList.notifyListeners();
              },
              child: SizedBox(
                width: 200,
                //color: Colors.red,
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.audioList[widget.index].title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      widget.audioList[widget.index].artist!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: ValueListenableBuilder(
                valueListenable: favNotifier,
                builder: (context, favlist, child) {
                  //here id and song list available.
                  Favourites currentSong = Favourites(
                      title: widget.audioList[widget.index].title,
                      artist: widget.audioList[widget.index].artist,
                      id: widget.audioList[widget.index].id,
                      uri: widget.audioList[widget.index].uri,
                      duration: widget.audioList[widget.index].duration);

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
                    element.id == widget.audioList[widget.index].id);
                //---------------------------------------------------------------------
                if (checkFavouriteStatus(getIndexSong)) {
                  addToFavouritesDB(getIndexSong);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(milliseconds: 500),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Song added to Favourites',
                      )));
                } else if (!checkFavouriteStatus(getIndexSong)) {
                  removeFromFavouritesDb(getIndexSong);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Song Removed From Favourites',
                      )));
                }
              },
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
