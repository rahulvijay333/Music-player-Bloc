import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:hive_music_player/common/common.dart';

import 'package:hive_music_player/common/widgets/menu_tile.dart';
import 'package:hive_music_player/hive/db_functions/mostly_played/moslty_played_function.dart';
import 'package:hive_music_player/hive/db_functions/recentlyPlayed/recently_function.dart';
import 'package:hive_music_player/hive/db_functions/splash/splash_functions.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/recently_played/recently_model.dart';
import 'package:hive_music_player/screens/all%20songs/screen_allSongs.dart';
import 'package:hive_music_player/screens/favourites/screen_favourites.dart';
import 'package:hive_music_player/screens/miniPlayer/mini_player.dart';
import 'package:hive_music_player/screens/mostly_played/screen_mostlyPlayed.dart';
import 'package:hive_music_player/screens/now_playing/screen_now_playing.dart';
import 'package:hive_music_player/screens/playlists/screen/screen_playlits.dart';
import 'package:hive_music_player/screens/settings/screen_settings.dart';

import 'widgets/recentlyPlayed_tile.dart';

ValueNotifier<bool> miniPlayerStatusNotifier = ValueNotifier(false);
ValueNotifier<int> miniPlayerIndex = ValueNotifier(0);
ValueNotifier<int> miniPlayerScreenIndex = ValueNotifier(0);
ValueNotifier<int> nowPlayingIndex = ValueNotifier(0);
bool showMiniPlayer = false;

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final recentBox = RecentlyPlayedBox.getinstance();

  @override
  void initState() {
    justAudioPlayerObject.currentIndexStream.listen((index) {
      if (index != null && mounted && globalMiniList.value.isNotEmpty) {
        nowPlayingIndex.value = index;

        //index
        // miniPlayerIndex.value = index;
        // miniPlayerScreenIndex.value = index;

        // miniPlayerStatusNotifier.value = true;
        // miniPlayerStatusNotifier.notifyListeners();

        // //index
        // miniPlayerIndex.notifyListeners();
        // miniPlayerScreenIndex.notifyListeners();
        // nowPlayingIndex.notifyListeners();

        if (globalMiniList.value.isNotEmpty) {
         
          updateMostlyPlayedDB(globalMiniList.value[index]);

          //recentply played
          final recentSong = RecentlyPlayed(
              globalMiniList.value[index].title,
              globalMiniList.value[index].artist,
              globalMiniList.value[index].id,
              globalMiniList.value[index].uri,
              globalMiniList.value[index].duration);

          updateRecentPlay(recentSong);
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const ScreenSettings();
                  },
                ));
              },
              child: const Icon(Icons.settings)),
          backgroundColor: mainColor,
          title: const Text('RythemRider'),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () async {
                await refreshAllSongs();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Songs Refreshed')));
              },
              child: Row(
                children: const [
                  Icon(Icons.refresh),
                  Text('Refresh'),
                  SizedBox(
                    width: 5,
                  )
                ],
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                //color: Colors.red,
                width: double.infinity,
                height: 270,
                child: Column(
                  children: [
                    //----------------------------row playlist and favouruties
                    Row(
                     
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx1) {
                                  return ScreenPlaylists();
                                },
                              ));
                            },
                            child: MenuTileWidget(
                              categoryName: 'PlayList',
                              size: size,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        //--------------------favourites
                        GestureDetector(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx1) {
                                  return const ScreenFavourtites();
                                },
                              ));
                            },
                            child: MenuTileWidget(
                              categoryName: 'Favourites',
                              size: size,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    //--------------------------------most played and all songs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ScreenMostlyPlayed();
                              },
                            ));
                          },
                          child: MenuTileWidget(
                            categoryName: 'Most Played',
                            size: size,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //----------------------all
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx1) {
                                  return ScreenAllSongs();
                                },
                              ));
                            },
                            child: MenuTileWidget(
                              categoryName: 'All Songs',
                              size: size,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              const Text(
                'Recently Played',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),

              //---------------------------------------------recently played
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: recentBox.listenable(),
                    builder: (context, Box<RecentlyPlayed> box, child) {
                      final recentlist = box.values.toList();
                      final recent = recentlist.reversed.toList();

                      if (recentlist.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Recent Songs',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10,
                          crossAxisCount: 3,
                        ),
                        itemCount: recent.length > 9 ? 9 : recent.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return GestureDetector(
                            onDoubleTap: () async {
                              await deleteRecentlyPlayed(recent[index].id!);
                            },
                            onTap: () {
                              //-------------------------------------------------convert into audiomodel list before sending to player screen
                              List<AudioModel> audioList =
                                  convertRecentlyPlayedToAudioModel(recent);

                              final recentSong = RecentlyPlayed(
                                  audioList[index].title,
                                  audioList[index].artist,
                                  audioList[index].id,
                                  audioList[index].uri,
                                  audioList[index].duration);
                              updateRecentPlay(recentSong);
                              updateMostlyPlayedDB(audioList[index]);

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return ScreenNowPlaying(
                                    songs: audioList,
                                    index: index,
                                  );
                                },
                              ));
                              //----------------------------------------------------update mini player list
                              globalMiniList.value.clear();
                              globalMiniList.value.addAll(audioList);
                              globalMiniList.notifyListeners();
                            },
                            child: RecentlyPlayedCustomTile(
                              songName: recent[index].title!,
                              artistName: recent[index].artist!,
                              list: recent,
                              index: index,
                            ),
                          );

                          //
                        },
                      );
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
