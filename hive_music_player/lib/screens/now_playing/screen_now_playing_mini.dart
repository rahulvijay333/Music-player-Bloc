import 'package:flutter/material.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/hive/db_functions/favourites/fav_function.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/fav/fav_mode.dart';
import 'package:hive_music_player/screens/all%20songs/widgets/show_playlist_dialoge.dart';
import 'package:hive_music_player/screens/home/screen_home.dart';
import 'package:hive_music_player/screens/miniPlayer/mini_player.dart';
import 'package:hive_music_player/screens/now_playing/progreasBar/progress_bar.dart';

import 'package:on_audio_query/on_audio_query.dart';

int miniScreenIndex = 0;

class ScreenNowPlaying1 extends StatefulWidget {
  const ScreenNowPlaying1({super.key, r, required this.passSongList});

  final List<AudioModel> passSongList;

  @override
  State<ScreenNowPlaying1> createState() => _ScreenNowPlaying1State();
}

class _ScreenNowPlaying1State extends State<ScreenNowPlaying1> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          backgroundColor: mainColor,
          appBar: AppBar(
            title: const Text('Now Playing'),
            centerTitle: true,
            backgroundColor: mainColor,
          ),
          body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        const SizedBox(
                          height: 10,
                        ),

                        //------------------------------song image
                        ValueListenableBuilder(
                          valueListenable: miniPlayerScreenIndex,
                          builder: (context, value, child) {
                            return QueryArtworkWidget(
                                artworkWidth: size.width * 0.85,
                                artworkHeight: size.height * 0.45,
                                artworkBorder: BorderRadius.circular(10),
                                nullArtworkWidget: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/song_tile_empty.png',
                                    width: size.width * 0.85,
                                    height: size.height * 0.45,
                                    //height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                id: widget
                                    .passSongList[miniPlayerScreenIndex.value]
                                    .id!,
                                type: ArtworkType.AUDIO);
                          },
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                        //----------------------------------player controller
                        ClipRRect(
                            borderRadius: BorderRadiusDirectional.circular(15),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5)),
                                width: size.width * 0.85,
                                height: size.height * 0.30,
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    //----------------------------------------song title
                                    child: ValueListenableBuilder(
                                      valueListenable: miniPlayerScreenIndex,
                                      builder: (context, value, child) {
                                        return Text(
                                          widget
                                              .passSongList[
                                                  miniPlayerScreenIndex.value]
                                              .title!,
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        );
                                      },
                                    ),
                                  ),
                                  //---------------------------------------artist name
                                  ValueListenableBuilder(
                                    valueListenable: miniPlayerIndex,
                                    builder: (context, index, child) {
                                      return Text(
                                        widget.passSongList[index].artist!,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                      );
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  //--------------------------------------------------progressbar
                                  const CustomProgressBar(),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          final allbox = MusicBox.getInstance();
                                          final allSongsList =
                                              allbox.values.toList();
                                          //-------------------------------------------check current song index from allsng db
                                          int getIndexSong = allSongsList
                                              .indexWhere((element) =>
                                                  element.id ==
                                                  widget
                                                      .passSongList[
                                                          miniPlayerScreenIndex
                                                              .value]
                                                      .id);

                                          showPlaylistDialog(
                                              context, getIndexSong);
                                        },
                                        child: const Icon(
                                          Icons.playlist_add,
                                          size: 25,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: favNotifier,
                                        builder: (context, favlist, child) {
                                          return IconButton(
                                            icon: ValueListenableBuilder(
                                              valueListenable:
                                                  miniPlayerScreenIndex,
                                              builder: (context, index, child) {
                                                //here id and song list available.

                                                Favourites currentSong =
                                                    Favourites(
                                                        title: widget
                                                            .passSongList[index]
                                                            .title,
                                                        artist: widget
                                                            .passSongList[index]
                                                            .artist,
                                                        id: widget
                                                            .passSongList[index]
                                                            .id,
                                                        uri:
                                                            widget
                                                                .passSongList[
                                                                    index]
                                                                .uri,
                                                        duration: widget
                                                            .passSongList[index]
                                                            .duration);

                                                if (favNotifier.value
                                                    .where((fav) =>
                                                        fav.id ==
                                                        currentSong.id)
                                                    .isEmpty) {
                                                  return const Icon(
                                                      Icons.favorite_outline,
                                                      color: Colors.black);
                                                } else {
                                                  return const Icon(
                                                    Icons.favorite,
                                                    color: Color.fromARGB(
                                                        255, 172, 29, 19),
                                                  );
                                                }
                                              },
                                            ),
                                            onPressed: () {
                                              //--------------------------------------------get allsong db
                                              final allbox =
                                                  MusicBox.getInstance();
                                              final allSongsList =
                                                  allbox.values.toList();
                                              //-------------------------------------------check current song index from allsng db
                                              int getIndexSong = allSongsList
                                                  .indexWhere((element) =>
                                                      element.id ==
                                                      widget
                                                          .passSongList[
                                                              nowPlayingIndex
                                                                  .value]
                                                          .id);
                                              // ---------------------------------------------Add to favorites
                                              if (checkFavouriteStatus(
                                                  getIndexSong)) {
                                                addToFavouritesDB(getIndexSong);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            duration: Duration(
                                                                seconds: 1),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            content: Text(
                                                              'Song added to Favourites',
                                                            )));
                                              } else if (!checkFavouriteStatus(
                                                  getIndexSong)) {
                                                //-----------------------------------------------remove from fav
                                                removeFromFavouritesDb(
                                                    getIndexSong);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        duration: Duration(
                                                            seconds: 1),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        content: Text(
                                                            'Song removed from Favourites')));
                                              }
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //-----------------------------------seekbutton
                                      GestureDetector(
                                        onTap: () {
                                          //------------------------------------------seek previous
                                          if (justAudioPlayerObject
                                              .hasPrevious) {
                                            justAudioPlayerObject
                                                .seekToPrevious();
                                          }
                                        },
                                        child: const Icon(
                                          Icons.skip_previous,
                                          size: 40,
                                        ),
                                      ),

                                      //-----------------------------------------play or pause button
                                      GestureDetector(
                                        onTap: () {
                                          if (justAudioPlayerObject.playing) {
                                            justAudioPlayerObject.pause();
                                          } else {
                                            if (justAudioPlayerObject
                                                    .currentIndex !=
                                                null) {
                                              justAudioPlayerObject.play();
                                            }
                                          }
                                        },
                                        child: StreamBuilder<bool>(
                                          stream: justAudioPlayerObject
                                              .playingStream,
                                          builder: (context, snapshot) {
                                            bool? playingState = snapshot.data;

                                            if (playingState != null &&
                                                playingState) {
                                              return const CircleAvatar(
                                                backgroundColor: Colors.black,
                                                radius: 25,
                                                child: Icon(
                                                  Icons.pause,
                                                  size: 40,
                                                ),
                                              );
                                            }

                                            return const CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.black,
                                              child: Icon(
                                                Icons.play_arrow,
                                                size: 40,
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      //---------------------------------------seek next function
                                      GestureDetector(
                                        onTap: () {
                                          if (justAudioPlayerObject.hasNext) {
                                            justAudioPlayerObject.seekToNext();
                                          }
                                        },
                                        child: const Icon(
                                          Icons.skip_next,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(
                                  //   height: 15,
                                  // ),
                                ])))
                      ]))))),
    );
  }
}
