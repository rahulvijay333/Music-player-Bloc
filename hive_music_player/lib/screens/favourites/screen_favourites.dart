import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/hive/db_functions/favourites/fav_function.dart';
import 'package:hive_music_player/hive/model/fav/fav_mode.dart';
import 'package:hive_music_player/screens/home/screen_home.dart';
import 'package:hive_music_player/screens/miniPlayer/mini_player.dart';
import 'widgets/favourite_tile.dart';

class ScreenFavourtites extends StatelessWidget {
  const ScreenFavourtites({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: ValueListenableBuilder(
            valueListenable: miniPlayerStatusNotifier,
            builder: (context, value, child) {
              if (miniPlayerStatusNotifier.value) {
                return const MiniPlayer();
              } else {
                return const SizedBox();
              }
            },
          ),
          appBar: AppBar(
            title: const Text('Favourites'),
            centerTitle: true,
            backgroundColor: mainColor,
          ),
          backgroundColor: mainColor,
          body: ValueListenableBuilder(
            valueListenable: favouritesDbBox.listenable(),
            builder: (context, Box<Favourites> box, child) {
              final favlist = box.values.toList();

              if (box.values.isEmpty) {
                return const Center(
                  child: Text(
                    'No favourites Songs',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return FavouriteTileCustom(
                            songName: favlist[index].title!,
                            index: index,
                            id: favlist[index].id!,
                            size: size,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 2,
                          );
                        },
                        itemCount: favlist.length),
                  ),
                );
              }
            },
          )),
    );
  }
}
