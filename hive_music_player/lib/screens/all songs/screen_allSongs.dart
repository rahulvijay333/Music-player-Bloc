import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:hive_music_player/common/common.dart';

import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/screens/all%20songs/widgets/tile_all_songs.dart';
import 'package:hive_music_player/screens/home/screen_home.dart';
import 'package:hive_music_player/screens/miniPlayer/mini_player.dart';
import 'package:hive_music_player/screens/now_playing/screen_now_playing.dart';
import 'package:hive_music_player/screens/search/screen_search.dart';

class ScreenAllSongs extends StatelessWidget {
  ScreenAllSongs({
    super.key,
  });

  final songDb = MusicBox.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: globalMiniList,
          builder: (context, value, child) {
            return ValueListenableBuilder(
              valueListenable: miniPlayerStatusNotifier,
              builder: (context, value, child) {
                if (miniPlayerStatusNotifier.value) {
                  return const MiniPlayer();
                } else {
                  return const SizedBox();
                }
              },
            );
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
          child: songDb.values.isNotEmpty

              //------------------------------------------------------song list
              ? ValueListenableBuilder(
                  valueListenable: songDb.listenable(),
                  builder: (context, value, child) {
                    List<AudioModel> listFrmDb = songDb.values.toList();

                    return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AllSongTileWidget(
                            songlist: listFrmDb,
                            index: index,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: listFrmDb.length);
                  },
                )
              //---------------------------------------show when No songs available
              : const Center(
                  child: Text(
                    'No Songs',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}
