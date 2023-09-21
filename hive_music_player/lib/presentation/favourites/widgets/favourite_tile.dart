import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rythem_rider/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:rythem_rider/application/RecentlyPlayed/recently_played_bloc.dart';
import 'package:rythem_rider/application/favourites/favourites_bloc.dart';
import 'package:rythem_rider/application/now_playing/bloc/now_playing_bloc.dart';

import 'package:rythem_rider/common/common.dart';
import 'package:rythem_rider/domain/model/all_songs/model.dart';
import 'package:rythem_rider/domain/model/fav/fav_mode.dart';
import 'package:rythem_rider/domain/model/recently_played/recently_model.dart';
import 'package:rythem_rider/presentation/home/screen_home.dart';

import 'package:on_audio_query/on_audio_query.dart';

class FavouriteTileCustom extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.1,
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
                id: id,
                type: ArtworkType.AUDIO),
            const SizedBox(
              width: 10,
            ),

            //-----------------------------------------------------song name
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  //-----------------------------------------------convertion into audiomodel music collections concatenation purpose
                  final favlist = FavouriteBox.getinstance().values.toList();

                  List<AudioModel> favCollections =
                      convertToAudioModel(favlist);

                  final recentSong = RecentlyPlayed(
                      favCollections[index].title,
                      favCollections[index].artist,
                      favCollections[index].id,
                      favCollections[index].uri,
                      favCollections[index].duration);

//--------new update-----<<<<<<<<<<<<<<<<<<<<<<<<<
                  context.read<NowPlayingBloc>().add(PlaySelectedSong(
                      index: index,
                      songs: favCollections,
                      audioObj: justAudioPlayerObjectNew));

                  nowPlayingIndex.value = index;
                  nowPlayingIndex.notifyListeners();
                  miniPlayerActive.value = true;
                  showingMiniPlayer.value = false;

                  //<<<<<<<<<_______________________________________________________new update

                  //--------------------recently played bloc
                  BlocProvider.of<RecentlyPlayedBloc>(context)
                      .add(UpdateRecentlyplayed(recentSong: recentSong));

                  //--------------------mostply played bloc

                  BlocProvider.of<MostlyPlayedBloc>(context)
                      .add(UpdateMostlyPLayed(favCollections[index]));
                },
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        songName,
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

                  BlocProvider.of<FavouritesBloc>(context)
                      .add(DeleteFromFavourites(id));

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(8),
                      content: Text('Song removed from favourites')));
                },
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
