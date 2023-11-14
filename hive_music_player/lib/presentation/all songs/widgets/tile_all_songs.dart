import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rythem_rider/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:rythem_rider/application/RecentlyPlayed/recently_played_bloc.dart';
import 'package:rythem_rider/application/favourites/favourites_bloc.dart';
import 'package:rythem_rider/application/miniPlayer/mini_player_bloc.dart';
import 'package:rythem_rider/application/now_playing/bloc/now_playing_bloc.dart';
import 'package:rythem_rider/domain/model/fav/fav_mode.dart';
import 'package:rythem_rider/domain/model/all_songs/model.dart';
import 'package:rythem_rider/domain/model/recently_played/recently_model.dart';

import 'package:rythem_rider/presentation/all%20songs/widgets/show_playlist_dialoge.dart';
import 'package:rythem_rider/presentation/home/screen_home.dart';

import 'package:just_audio/just_audio.dart';
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

                  context.read<NowPlayingBloc>().add(PlaySelectedSong(
                      index: index,
                      songs: songlist,
                      audioObj: justAudioPlayerObjectNew));

                  nowPlayingIndex.value = index;
                  nowPlayingIndex.notifyListeners();
                  miniPlayerActive.value = true;
                  showingMiniPlayer.value = false;
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      songlist[index].title ?? 'Unavailable',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    Text(
                      songlist[index].artist ?? "Unavailable",
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

  ConcatenatingAudioSource createPlaylist(List<AudioModel> songs) {
    List<AudioSource> sources = [];

    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }
}
