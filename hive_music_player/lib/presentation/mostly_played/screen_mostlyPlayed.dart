import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:hive_music_player/application/miniPlayer/mini_player_bloc.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/domain/model/mostply_played/mosltly_played_model.dart';
import 'package:hive_music_player/presentation/miniPlayer/mini_player.dart';
import 'package:hive_music_player/presentation/mostly_played/widget/most_played_tile.dart';

class ScreenMostlyPlayed extends StatelessWidget {
  const ScreenMostlyPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MostlyPlayedBloc>(context).add(GetMostlyPlayed());
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
              title: const Text('Mostly Played'),
              centerTitle: true,
              backgroundColor: mainColor,
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
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
                        itemCount: mostlist.length > 15 ? 15 : mostlist.length);
                  }
                },
              ),
            )));
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
