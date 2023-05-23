import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/application/all%20songs/all_songs_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/miniPlayer/mini_player_bloc.dart';
import 'package:hive_music_player/common/common.dart';

import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/screens/all%20songs/widgets/tile_all_songs.dart';
import 'package:hive_music_player/screens/miniPlayer/mini_player.dart';
import 'package:hive_music_player/screens/search/screen_search.dart';

class ScreenAllSongs extends StatelessWidget {
  ScreenAllSongs({
    super.key,
  });

  final songDb = MusicBox.getInstance();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AllSongsBloc>(context).add(GetAllSongs());

    return SafeArea(
      child: BlocBuilder<AllSongsBloc, AllSongsState>(
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
              builder: (context, state) {
                if (state.showPlayer == false || state.playingList.isEmpty) {
                  return const SizedBox();
                }
                return const MiniPlayer();
              },
            ),
            backgroundColor: mainColor,
            appBar: AppBar(
              title: const Text('All Songs'),
              centerTitle: true,
              backgroundColor: mainColor,
              actions: [
                //---------------------------------------search page redirect here
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const ScreenSearch();
                        },
                      ));
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: state.allsongs.isNotEmpty

                  //------------------------------------------------------song list
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return AllSongTileWidget(
                          songlist: state.allsongs,
                          index: index,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 5,
                        );
                      },
                      itemCount: state.allsongs.length)
                  //---------------------------------------show when No songs available
                  : const Center(
                      child: Text(
                        'No Songs',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
