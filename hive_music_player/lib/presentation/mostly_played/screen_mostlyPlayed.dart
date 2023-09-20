import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:hive_music_player/application/now_playing/bloc/now_playing_bloc.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/common/widgets/app_bar_custom.dart';
import 'package:hive_music_player/domain/model/mostply_played/mosltly_played_model.dart';
import 'package:hive_music_player/presentation/home/screen_home.dart';
import 'package:hive_music_player/presentation/mostly_played/widget/most_played_tile.dart';
import 'package:hive_music_player/presentation/now_playing/screen_now_playing.dart';

class ScreenMostlyPlayed extends StatelessWidget {
  const ScreenMostlyPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final size = MediaQuery.of(context).size;
    BlocProvider.of<MostlyPlayedBloc>(context).add(GetMostlyPlayed());
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        if (showingMiniPlayer.value == false) {
          showingMiniPlayer.value = true;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          backgroundColor: mainColor,
          body: Stack(
            children: [
              Column(
                children: [
                  CustomAppBar(size: size, heading: 'Mostly Played'),
                  Expanded(
                    child: BlocBuilder<MostlyPlayedBloc, MostlyPlayedState>(
                      builder: (context, state) {
                        List<MostlyPlayed> mostlist = [];
                        final mostlyPlayedList = state.mostlyList;

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
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Scrollbar(
                              controller: scrollController,

                              child: ListView.separated(
                                  controller: scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right:8.0),
                                      child: MostplayedTileCustom(
                                          index: index, mostlyList: mostlist),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemCount: mostlist.length > 15
                                      ? 15
                                      : mostlist.length),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: miniPlayerActive,
                builder: (context, isActive, child) {
                  return Visibility(
                      visible: isActive,
                      child: ValueListenableBuilder(
                        valueListenable: showingMiniPlayer,
                        builder: (context, value, child) {
                          return Positioned(
                              bottom: 0, // Adjust the position as needed
                              left: 0,
                              right: 0,
                              top: showingMiniPlayer.value ? null : 0,
                              child:
                                  BlocBuilder<NowPlayingBloc, NowPlayingState>(
                                builder: (context, state) {
                                  return  ScreenNowPlaying(songs: state.songsList!,);
                                },
                              ));
                        },
                      ));
                },
              )
            ],
          )),
    ));
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
                  //------------------------------------------lear mostply bloc played
                  BlocProvider.of<MostlyPlayedBloc>(context)
                      .add(ClearMostlyPlayed());

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
