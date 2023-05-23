import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:hive_music_player/application/RecentlyPlayed/recently_played_bloc.dart';
import 'package:hive_music_player/application/favourites/favourites_bloc.dart';
import 'package:hive_music_player/application/miniPlayer/mini_player_bloc.dart';
import 'package:hive_music_player/hive/model/fav/fav_mode.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/mostply_played/mosltly_played_model.dart';
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

//---------------------------------------------------------------------->>recently played bloc
                  BlocProvider.of<RecentlyPlayedBloc>(context)
                      .add(UpdateRecentlyplayed(recentSong: recentSong));
//----------------------------------------------------------------------->>mostly played bloc

                  BlocProvider.of<MostlyPlayedBloc>(context)
                      .add(UpdateMostlyPLayed(songlist[index]));

                  BlocProvider.of<MiniPlayerBloc>(context)
                      .add(CloseMiniPlayer());

                  updatingList.value.clear();
                  updatingList.value.addAll(songlist);
                  updatingList.notifyListeners();

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

            IconButton(icon: BlocBuilder<FavouritesBloc, FavouritesState>(
                builder: (context, state) {
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
            }), onPressed: () {
              // ---------------------------------------------Add to favorites bloc
              if (checkFavouriteStatus(index)) {
                BlocProvider.of<FavouritesBloc>(context)
                    .add(AddToFavourites(index));

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'Song added to Favourites',
                    )));
              } else if (!checkFavouriteStatus(index)) {
                //-----------------------------------------------remove from fav bloc

                BlocProvider.of<FavouritesBloc>(context)
                    .add(RemoveFromFavGeneral(index));

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'song removed from favourites',
                    )));
              }
            }),
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
