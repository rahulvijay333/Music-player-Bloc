import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/hive/db_functions/mostly_played/moslty_played_function.dart';
import 'package:hive_music_player/hive/model/mostply_played/mosltly_played_model.dart';
import 'package:hive_music_player/screens/home/screen_home.dart';
import 'package:hive_music_player/screens/miniPlayer/mini_player.dart';
import 'package:hive_music_player/screens/mostly_played/widget/most_played_tile.dart';
import 'package:hive_music_player/screens/now_playing/screen_now_playing.dart';

class ScreenMostlyPlayed extends StatelessWidget {
  ScreenMostlyPlayed({super.key});

  final mostbox = MostplePlayedBox.getInstance();

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
              title: const Text('Mostly Played'),
              centerTitle: true,
              backgroundColor: mainColor,
            ),
            body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ValueListenableBuilder(
                  valueListenable: mostbox.listenable(),
                  builder: (context, mostplaylist, child) {
                    List<MostlyPlayed> mostlist = [];
                    final mostlyPlayedList = mostbox.values.toList();

                    //finding most played song and adding to mostlist
                    for (var song in mostlyPlayedList) {
                      if (song.count > 5) {
                        mostlist.add(song);
                      }
                    }

                    mostlist.sort((a, b) => b.count.compareTo(a.count));

                    if (mostlist.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Songs',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      return ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MostplayedTileCustom(
                                index: index, mostlyList: mostlist);
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount:
                              mostlist.length > 15 ? 15 : mostlist.length);
                    }
                  },
                ))));
  }

  clearSongDialoge(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx1) {
        return AlertDialog(
          backgroundColor: Colors.transparent.withOpacity(0.8),
          title: const Text(
            'Important',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Do you want to clear mostlyPlayed songs ?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  //clear function

                  await clearSongsFromMostlyPlayed(context);
                  Navigator.of(ctx1).pop();
                },
                child: const Text(
                  'yes',
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(ctx1).pop();
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        );
      },
    );
  }
}
