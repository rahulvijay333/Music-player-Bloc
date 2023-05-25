import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:hive_music_player/application/RecentlyPlayed/recently_played_bloc.dart';
import 'package:hive_music_player/application/miniPlayer/mini_player_bloc.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/common/widgets/menu_tile.dart';
import 'package:hive_music_player/domain/db_functions/splash/splash_functions.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
import 'package:hive_music_player/domain/model/recently_played/recently_model.dart';
import 'package:hive_music_player/presentation/all%20songs/screen_allSongs.dart';
import 'package:hive_music_player/presentation/favourites/screen_favourites.dart';
import 'package:hive_music_player/presentation/miniPlayer/mini_player.dart';
import 'package:hive_music_player/presentation/mostly_played/screen_mostlyPlayed.dart';
import 'package:hive_music_player/presentation/now_playing/screen_now_playing.dart';
import 'package:hive_music_player/presentation/playlists/screen/screen_playlits.dart';
import 'package:hive_music_player/presentation/settings/screen_settings.dart';
import 'package:just_audio/just_audio.dart';

import 'widgets/recentlyPlayed_tile.dart';

ValueNotifier<int> nowPlayingIndex = ValueNotifier(0);

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  void didChangeDependencies() {
    justAudioPlayerObject.currentIndexStream.listen((index) {
      if (index != null &&
          mounted &&
          updatingList.value.isNotEmpty != null &&
          justAudioPlayerObject.playerState.playing &&
          justAudioPlayerObject.playerState.processingState !=
              ProcessingState.idle) {
        nowPlayingIndex.value = index;
        BlocProvider.of<MiniPlayerBloc>(context).add(UpdateMiniIndex(index));

        //---------------------------------------------------------------------->>recently played bloc
        try {
          final recentSong = RecentlyPlayed(
              updatingList.value[index].title,
              updatingList.value[index].artist,
              updatingList.value[index].id,
              updatingList.value[index].uri,
              updatingList.value[index].duration);

          BlocProvider.of<RecentlyPlayedBloc>(context)
              .add(UpdateRecentlyplayed(recentSong: recentSong));
        } catch (e) {}
// //----------------------------------------------------------------------->>mostly played bloc

        BlocProvider.of<MostlyPlayedBloc>(context)
            .add(UpdateMostlyPLayed(updatingList.value[index]));
      }
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //-------------------------------------------------recently bloc

    BlocProvider.of<RecentlyPlayedBloc>(context).add(GetRecentlyPlayed());

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
          builder: (context, state) {
            if (state.showPlayer == false) {
              return const SizedBox();
            }
            return const MiniPlayer();
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
                  child: BlocBuilder<RecentlyPlayedBloc, RecentlyPlayedState>(
                builder: (context, state) {
                  if (state.recentList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Recently Played Songs',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10, crossAxisCount: 3),
                      itemCount: state.recentList.length > 9
                          ? 9
                          : state.recentList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            final recentSong = RecentlyPlayed(
                                state.recentList[index].title,
                                state.recentList[index].artist,
                                state.recentList[index].id,
                                state.recentList[index].uri,
                                state.recentList[index].duration);

//---------------------------------------------------------------------->>recently played bloc
                            BlocProvider.of<RecentlyPlayedBloc>(context).add(
                                UpdateRecentlyplayed(recentSong: recentSong));
//----------------------------------------------------------------------->>mostly played bloc

                            BlocProvider.of<MostlyPlayedBloc>(context).add(
                                UpdateMostlyPLayed(state.recentList[index]));
                            //-----------------------------------------------------

                            BlocProvider.of<MiniPlayerBloc>(context)
                                .add(CloseMiniPlayer());
                            //----------------------------

                            updatingList.value.clear();
                            updatingList.value = state.recentList;
                            updatingList.notifyListeners();

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ScreenNowPlaying(
                                  songs: state.recentList,
                                  index: index,
                                );
                              },
                            ));
                          },
                          onDoubleTap: () async {
                            // ------------------------------------------------delete bloc recently played song
                            BlocProvider.of<RecentlyPlayedBloc>(context).add(
                                DeleteRecentlyPlayed(
                                    id: state.recentList[index].id!));
                          },
                          child: RecentlyPlayedCustomTile(
                              songName: state.recentList[index].title!,
                              artistName: state.recentList[index].artist!,
                              list: state.recentList,
                              index: index),
                        );
                      },
                    );
                  }
                },
              )),
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
