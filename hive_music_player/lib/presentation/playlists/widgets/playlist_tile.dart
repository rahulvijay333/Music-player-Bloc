import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rythem_rider/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:rythem_rider/application/RecentlyPlayed/recently_played_bloc.dart';
import 'package:rythem_rider/application/favourites/favourites_bloc.dart';
import 'package:rythem_rider/application/miniPlayer/mini_player_bloc.dart';
import 'package:rythem_rider/application/now_playing/bloc/now_playing_bloc.dart';
import 'package:rythem_rider/application/playlist/playlist_bloc.dart';

import 'package:rythem_rider/domain/model/all_songs/model.dart';
import 'package:rythem_rider/domain/model/fav/fav_mode.dart';
import 'package:rythem_rider/domain/model/recently_played/recently_model.dart';
import 'package:rythem_rider/presentation/home/screen_home.dart';
import 'package:on_audio_query/on_audio_query.dart';

//tile containing fav and delete function

//----------------------------------------playlist song list

class PlaylistSongsTileCustom extends StatelessWidget {
  const PlaylistSongsTileCustom(
      {super.key,
      required this.songlist,
      required this.index,
      required this.playlistindex});

  final List<AudioModel> songlist;
  final int index;
  final int playlistindex;

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
                id: songlist[index].id!,
                type: ArtworkType.AUDIO),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  //----------------------------------------------click to play
                  final recentSong = RecentlyPlayed(
                      songlist[index].title,
                      songlist[index].artist,
                      songlist[index].id,
                      songlist[index].uri,
                      songlist[index].duration);

                  //---------------------------recently played
                  BlocProvider.of<RecentlyPlayedBloc>(context)
                      .add(UpdateRecentlyplayed(recentSong: recentSong));

                  //-------------------------->>mostply played

                  BlocProvider.of<MostlyPlayedBloc>(context)
                      .add(UpdateMostlyPLayed(songlist[index]));
//-------------------
                  BlocProvider.of<MiniPlayerBloc>(context)
                      .add(CloseMiniPlayer());

                  //---<<<<-------------------------------------------------------------------latest update
                  context.read<NowPlayingBloc>().add(PlaySelectedSong(
                      index: index,
                      songs: songlist,
                      audioObj: justAudioPlayerObjectNew));

                  nowPlayingIndex.value = index;
                  nowPlayingIndex.notifyListeners();
                  miniPlayerActive.value = true;
                  showingMiniPlayer.value = false;
                  //-------------------------------------------------------


             
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
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    Text(
                      songlist[index].artist!,
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
              icon: BlocBuilder<FavouritesBloc, FavouritesState>(
                builder: (context, state) {
                  //here id and song list available.
                  Favourites currentSong = Favourites(
                      title: songlist[index].title,
                      artist: songlist[index].artist,
                      id: songlist[index].id,
                      uri: songlist[index].uri,
                      duration: songlist[index].duration);

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
                int getIndexSong = allSongsList
                    .indexWhere((element) => element.id == songlist[index].id);
                //---------------------------------------------------------------------
                if (checkFavouriteStatus(getIndexSong)) {
                  //--------------------------------------------------fav bloc here
                  BlocProvider.of<FavouritesBloc>(context)
                      .add(AddToFavourites(getIndexSong));

                  //snackbar
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Song added to Favourites',
                      )));
                } else if (!checkFavouriteStatus(getIndexSong)) {
                  //-------------------------------------------------fav delete bloc here
                  BlocProvider.of<FavouritesBloc>(context)
                      .add(RemoveFromFavGeneral(getIndexSong));

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
                //-------------------------------------------------bloc delete from playlist
                BlocProvider.of<PlaylistBloc>(context)
                    .add(DeleteFromPlaylist(playlistindex, index));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('song removed'),
                  duration: Duration(seconds: 1),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
