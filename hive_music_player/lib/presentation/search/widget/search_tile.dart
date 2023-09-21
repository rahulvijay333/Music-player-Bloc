import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rythem_rider/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:rythem_rider/application/RecentlyPlayed/recently_played_bloc.dart';
import 'package:rythem_rider/application/favourites/favourites_bloc.dart';
import 'package:rythem_rider/application/miniPlayer/mini_player_bloc.dart';
import 'package:rythem_rider/application/now_playing/bloc/now_playing_bloc.dart';
import 'package:rythem_rider/domain/model/all_songs/model.dart';
import 'package:rythem_rider/domain/model/fav/fav_mode.dart';
import 'package:rythem_rider/domain/model/recently_played/recently_model.dart';
import 'package:rythem_rider/presentation/home/screen_home.dart';
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

                FocusScope.of(context).unfocus();
                //---<<<<-------------------------------------------------------------------latest update
                context.read<NowPlayingBloc>().add(PlaySelectedSong(
                    index: widget.index,
                    songs: widget.audioList,
                    audioObj: justAudioPlayerObjectNew));

                nowPlayingIndex.value = widget.index;
                nowPlayingIndex.notifyListeners();
                miniPlayerActive.value = true;
                showingMiniPlayer.value = false;
                final recentSong = RecentlyPlayed(
                    widget.audioList[widget.index].title,
                    widget.audioList[widget.index].artist,
                    widget.audioList[widget.index].id,
                    widget.audioList[widget.index].uri,
                    widget.audioList[widget.index].duration);

                BlocProvider.of<RecentlyPlayedBloc>(context)
                    .add(UpdateRecentlyplayed(recentSong: recentSong));

                //------------->>mostply played bloc
                BlocProvider.of<MostlyPlayedBloc>(context)
                    .add(UpdateMostlyPLayed(widget.audioList[widget.index]));
//------------------------------
                BlocProvider.of<MiniPlayerBloc>(context).add(CloseMiniPlayer());
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
              icon: BlocBuilder<FavouritesBloc, FavouritesState>(
                builder: (context, state) {
                  //here id and song list available.
                  Favourites currentSong = Favourites(
                      title: widget.audioList[widget.index].title,
                      artist: widget.audioList[widget.index].artist,
                      id: widget.audioList[widget.index].id,
                      uri: widget.audioList[widget.index].uri,
                      duration: widget.audioList[widget.index].duration);

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
                    element.id == widget.audioList[widget.index].id);
                //---------------------------------------------------------------------
                if (checkFavouriteStatus(getIndexSong)) {
                  // -----------------------------------------fav add bloc
                  BlocProvider.of<FavouritesBloc>(context)
                      .add(AddToFavourites(getIndexSong));

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(milliseconds: 500),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Song added to Favourites',
                      )));
                } else if (!checkFavouriteStatus(getIndexSong)) {
                  //-------------------------------------------------fav delete bloc here
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
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
