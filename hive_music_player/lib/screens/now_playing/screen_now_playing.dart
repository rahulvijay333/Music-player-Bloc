import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/favourites/favourites_bloc.dart';
import 'package:hive_music_player/application/miniPlayer/mini_player_bloc.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/fav/fav_mode.dart';
import 'package:hive_music_player/screens/all%20songs/widgets/show_playlist_dialoge.dart';
import 'package:hive_music_player/screens/home/screen_home.dart';
import 'package:hive_music_player/screens/miniPlayer/mini_player.dart';
import 'package:hive_music_player/screens/now_playing/progreasBar/progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier<List<AudioModel>> globalMiniList = ValueNotifier([]);

ValueNotifier<List<AudioModel>> updatingList = ValueNotifier([]);

class ScreenNowPlaying extends StatefulWidget {
  const ScreenNowPlaying({
    super.key,
    required this.songs,
    required this.index,
  });

  final List<AudioModel> songs;
  final int index;

  @override
  State<ScreenNowPlaying> createState() => _ScreenNowPlayingState();
}

class _ScreenNowPlayingState extends State<ScreenNowPlaying> {
  @override
  void initState() {
    

    callPlayer();

    super.initState();
  }

  callPlayer() async {
    await justAudioPlayerObject.setAudioSource(createPlaylist(widget.songs),
        initialIndex: widget.index);

    await justAudioPlayerObject.play();

  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MiniPlayerBloc>(context)
        .add(ShowMiniPLayer(widget.songs, widget.index));

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
                    //---------------------------------------------song image
                    ValueListenableBuilder(
                      valueListenable: nowPlayingIndex,
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
                            id: widget.songs[nowPlayingIndex.value].id!,
                            type: ArtworkType.AUDIO);
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    //-----------------------------------------------player container
                    ClipRRect(
                      borderRadius: BorderRadiusDirectional.circular(15),
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.white.withOpacity(0.5)),
                        width: size.width * 0.85,
                        height: size.height * 0.30,
                        child: Column(
                          children: [
                            //----------------------------song title
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ValueListenableBuilder(
                                valueListenable: nowPlayingIndex,
                                builder: (context, value, child) {
                                  return SizedBox(
                                    width: size.width * 0.7,
                                    // color: Colors.red,
                                    child: Center(
                                      child: Text(
                                        widget.songs[nowPlayingIndex.value]
                                            .title!,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: nowPlayingIndex,
                              builder: (context, value, child) {
                                return SizedBox(
                                  width: size.width * 0.7,
                                  child: Center(
                                    child: Text(
                                      widget
                                          .songs[nowPlayingIndex.value].artist!,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
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
                                //--------------------playlist add
                                GestureDetector(
                                  onTap: () {
                                    final allbox = MusicBox.getInstance();
                                    final allSongsList = allbox.values.toList();
                                    //-------------------------------------------check current song index from allsng db
                                    int getIndexSong = allSongsList.indexWhere(
                                        (element) =>
                                            element.id ==
                                            widget.songs[nowPlayingIndex.value]
                                                .id);

                                    showPlaylistDialog(context, getIndexSong);
                                  },
                                  child: const Icon(
                                    Icons.playlist_add,
                                    size: 25,
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                //---------------------------------------------------------favourites
                                ValueListenableBuilder(
                                  valueListenable: nowPlayingIndex,
                                  builder: (context, value, child) {
                                    return IconButton(
                                      icon: BlocBuilder<FavouritesBloc,
                                          FavouritesState>(
                                        builder: (context, state) {
                                          //here id and song list available.
                                          Favourites currentSong = Favourites(
                                              title: widget
                                                  .songs[nowPlayingIndex.value]
                                                  .title,
                                              artist: widget
                                                  .songs[nowPlayingIndex.value]
                                                  .artist,
                                              id: widget
                                                  .songs[nowPlayingIndex.value]
                                                  .id,
                                              uri: widget
                                                  .songs[nowPlayingIndex.value]
                                                  .uri,
                                              duration: widget
                                                  .songs[nowPlayingIndex.value]
                                                  .duration);

                                          if (state.favlist
                                              .where((fav) =>
                                                  fav.id == currentSong.id)
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
                                        final allbox = MusicBox.getInstance();
                                        final allSongsList =
                                            allbox.values.toList();
                                        //-------------------------------------------check current song index from allsng db
                                        int getIndexSong =
                                            allSongsList.indexWhere((element) =>
                                                element.id ==
                                                widget
                                                    .songs[
                                                        nowPlayingIndex.value]
                                                    .id);
                                        // ---------------------------------------------Add to favorites
                                        if (checkFavouriteStatus(
                                            getIndexSong)) {
                                          // addToFavouritesDB(getIndexSong);

                                          // addToFavouritesDB(index);
                                          BlocProvider.of<FavouritesBloc>(
                                                  context)
                                              .add(AddToFavourites(
                                                  getIndexSong));

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                    'Song added to Favourites',
                                                  )));
                                        } else if (!checkFavouriteStatus(
                                            getIndexSong)) {
                                          //-----------------------------------------------remove fav bloc

                                          BlocProvider.of<FavouritesBloc>(
                                                  context)
                                              .add(RemoveFromFavGeneral(
                                                  getIndexSong));

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  behavior:
                                                      SnackBarBehavior.floating,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //------------------------------------seekbutton
                                GestureDetector(
                                  onTap: () {
                                    //------------------------------------------seek previous
                                    if (justAudioPlayerObject.hasPrevious) {
                                      justAudioPlayerObject.seekToPrevious();
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
                                      if (justAudioPlayerObject.currentIndex !=
                                          null) {
                                        justAudioPlayerObject.play();
                                      }
                                    }
                                  },
                                  child: StreamBuilder<bool>(
                                    stream: justAudioPlayerObject.playingStream,
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
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  //--------------------------------------create playlist function
  ConcatenatingAudioSource createPlaylist(List<AudioModel> songs) {
    List<AudioSource> sources = [];

    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }
}
