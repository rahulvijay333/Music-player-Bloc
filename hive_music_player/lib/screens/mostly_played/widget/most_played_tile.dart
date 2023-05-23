import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:hive_music_player/application/RecentlyPlayed/recently_played_bloc.dart';
import 'package:hive_music_player/application/favourites/favourites_bloc.dart';
import 'package:hive_music_player/application/miniPlayer/mini_player_bloc.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/fav/fav_mode.dart';
import 'package:hive_music_player/hive/model/mostply_played/mosltly_played_model.dart';
import 'package:hive_music_player/hive/model/recently_played/recently_model.dart';
import 'package:hive_music_player/screens/now_playing/screen_now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostplayedTileCustom extends StatefulWidget {
  const MostplayedTileCustom(
      {super.key, required this.mostlyList, required this.index});

  final List<MostlyPlayed> mostlyList;
  final int index;

  @override
  State<MostplayedTileCustom> createState() => _MostplayedTileCustomState();
}

class _MostplayedTileCustomState extends State<MostplayedTileCustom> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.transparent.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              const SizedBox(
                width: 5,
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
                  id: widget.mostlyList[widget.index].id!,
                  type: ArtworkType.AUDIO),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    //---------------------------------------------play function  here
                    //convert mostly to audiomodel
                    List<AudioModel> audiolist =
                        convertMostlyPlayedToAudioModelList(widget.mostlyList);

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return ScreenNowPlaying(
                          songs: audiolist,
                          index: widget.index,
                        );
                      },
                    ));
                    final recentSong = RecentlyPlayed(
                        audiolist[widget.index].title,
                        audiolist[widget.index].artist,
                        audiolist[widget.index].id,
                        audiolist[widget.index].uri,
                        audiolist[widget.index].duration);

                    final mostSong = AudioModel(
                        title: audiolist[widget.index].title,
                        artist: audiolist[widget.index].artist,
                        id: audiolist[widget.index].id,
                        uri: audiolist[widget.index].uri,
                        duration: audiolist[widget.index].duration);

//------------->>recently played bloc
                    BlocProvider.of<RecentlyPlayedBloc>(context)
                        .add(UpdateRecentlyplayed(recentSong: recentSong));
//------------->>mostply played bloc
                    BlocProvider.of<MostlyPlayedBloc>(context)
                        .add(UpdateMostlyPLayed(mostSong));
//------------------------------
                        BlocProvider.of<MiniPlayerBloc>(context)
                      .add(CloseMiniPlayer());

                    //update mini player list
                    updatingList.value.clear();
                    updatingList.value.addAll(audiolist);
                    updatingList.notifyListeners();
                  },
                  child: Text(
                    widget.mostlyList[widget.index].title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),

              //-----------------------------------------------favourite function here-----------
              IconButton(
                icon: BlocBuilder<FavouritesBloc, FavouritesState>(
                  builder: (context, state) {
                    //here id and song list available.
                    Favourites currentSong = Favourites(
                        title: widget.mostlyList[widget.index].title,
                        artist: widget.mostlyList[widget.index].artist,
                        id: widget.mostlyList[widget.index].id,
                        uri: widget.mostlyList[widget.index].uri,
                        duration: widget.mostlyList[widget.index].duration);

                    if (state.favlist
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
                      element.id == widget.mostlyList[widget.index].id);
                  //---------------------------------------------------------------------
                  if (checkFavouriteStatus(getIndexSong)) {
                    // addToFavouritesDB(getIndexSong);
                    //------------------------------------------------fav bloc here
                    BlocProvider.of<FavouritesBloc>(context)
                        .add(AddToFavourites(getIndexSong));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          'Song added to Favourites',
                        )));
                  } else if (!checkFavouriteStatus(getIndexSong)) {
                    // removeFromFavouritesDb(getIndexSong);
                    //--------------------------------------------------fav bloc here
                    BlocProvider.of<FavouritesBloc>(context)
                        .add(RemoveFromFavGeneral(getIndexSong));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          'Song Removed From Favourites',
                        )));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
