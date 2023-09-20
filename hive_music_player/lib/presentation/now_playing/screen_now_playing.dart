import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/RecentlyPlayed/recently_played_bloc.dart';
import 'package:hive_music_player/application/favourites/favourites_bloc.dart';
import 'package:hive_music_player/application/now_playing/bloc/now_playing_bloc.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
import 'package:hive_music_player/domain/model/fav/fav_mode.dart';
import 'package:hive_music_player/domain/model/recently_played/recently_model.dart';
import 'package:hive_music_player/presentation/all%20songs/widgets/show_playlist_dialoge.dart';
import 'package:hive_music_player/presentation/home/screen_home.dart';
import 'package:hive_music_player/presentation/now_playing/progreasBar/progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenNowPlaying extends StatefulWidget {
  const ScreenNowPlaying({
    super.key,
    required this.songs,
  });
  final List<AudioModel> songs;

  @override
  State<ScreenNowPlaying> createState() => _ScreenNowPlayingState();
}

class _ScreenNowPlayingState extends State<ScreenNowPlaying> {
  @override
  void initState() {
    super.initState();

    justAudioPlayerObjectNew.currentIndexStream.listen((index) {
      if (index != null &&
          justAudioPlayerObjectNew.playerState.playing &&
          justAudioPlayerObjectNew.playerState.processingState !=
              ProcessingState.idle) {
        nowPlayingIndex.value = index;

        final recentSong = RecentlyPlayed(
            widget.songs[index].title,
            widget.songs[index].artist,
            widget.songs[index].id,
            widget.songs[index].uri,
            widget.songs[index].duration);

        BlocProvider.of<RecentlyPlayedBloc>(context)
            .add(UpdateRecentlyplayed(recentSong: recentSong));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<NowPlayingBloc, NowPlayingState>(
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: showingMiniPlayer,
          builder: (context, miniStatus, child) {
            if (miniStatus == true) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.black,
                    height: 60,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        QueryArtworkWidget(
                            artworkWidth: 40,
                            artworkHeight: 35,
                            artworkBorder: BorderRadius.circular(10),
                            nullArtworkWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/song_tile_empty.png',
                                width: 40,
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                            id: state.songsList![nowPlayingIndex.value].id!,
                            type: ArtworkType.AUDIO),
                        const SizedBox(
                          width: 5,
                        ),

                        Expanded(
                            child: GestureDetector(
                                onTap: () async {
                                  showingMiniPlayer.value = false;
                                },
                                child: ValueListenableBuilder(
                                  valueListenable: nowPlayingIndex,
                                  builder: (context, value, child) {
                                    return Text(
                                      state.songsList![nowPlayingIndex.value]
                                          .title!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    );
                                  },
                                ))),

                        //------------------------------------seekbutton
                        GestureDetector(
                          onTap: () {
                            //------------------------------------------seek previous
                            if (justAudioPlayerObjectNew.hasPrevious) {
                              justAudioPlayerObjectNew.seekToPrevious();
                            }
                          },
                          child: const Icon(
                            Icons.skip_previous,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),

                        //-----------------------------------------play or pause button
                        GestureDetector(
                          onTap: () async {
                            if (justAudioPlayerObjectNew.playing) {
                              await justAudioPlayerObjectNew.pause();
                            } else {
                              if (justAudioPlayerObjectNew.currentIndex !=
                                  null) {
                                justAudioPlayerObjectNew.play();
                              }
                            }
                          },
                          child: StreamBuilder<bool>(
                            stream: justAudioPlayerObjectNew.playingStream,
                            builder: (context, snapshot) {
                              bool? playingState = snapshot.data;

                              if (playingState != null && playingState) {
                                return const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 20,
                                  child: Icon(
                                    Icons.pause,
                                    size: 25,
                                  ),
                                );
                              }

                              return const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 30,
                                ),
                              );
                            },
                          ),
                        ),

                        //---------------------------------------seek next function
                        GestureDetector(
                          onTap: () {
                            if (justAudioPlayerObjectNew.hasNext) {
                              justAudioPlayerObjectNew.seekToNext();
                            }
                          },
                          child: const Icon(
                            Icons.skip_next,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        //------------------------------------------mini player close function

                        GestureDetector(
                            onTap: () {
                              miniPlayerActive.value = false;

                              justAudioPlayerObjectNew.pause();
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                color: mainColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          Container(
                            // color: Colors.red,
                            width: size.width,
                            height: size.height * 0.07,
                            child: Center(
                                child: Text(
                              'Now Playing',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.04),
                            )),
                          ),
                          IconButton(
                              onPressed: () {
                                showingMiniPlayer.value = true;
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                  id: state
                                      .songsList![nowPlayingIndex.value].id!,
                                  type: ArtworkType.AUDIO);
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          ClipRRect(
                              borderRadius:
                                  BorderRadiusDirectional.circular(15),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5)),
                                  width: size.width * 0.85,
                                  // height: size.height * 0.40,
                                  child: Column(children: [
                                    //----------------------------song title
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ValueListenableBuilder(
                                        valueListenable: nowPlayingIndex,
                                        builder: (context, value, child) {
                                          return Container(
                                            width: size.width * 0.7,
                                            //  color: Colors.red,
                                            child: Center(
                                              child: Text(
                                                state
                                                    .songsList![
                                                        nowPlayingIndex.value]
                                                    .title!,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: size.width *
                                                        0.7 *
                                                        0.08),
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
                                              state
                                                  .songsList![
                                                      nowPlayingIndex.value]
                                                  .artist!,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize:
                                                      size.width * 0.7 * 0.04),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: size.height * 0.03,
                                    ),

                                    //--------------------------------------------------progressbar
                                    CustomProgressBar(
                                        justAudioPlayerObject:
                                            justAudioPlayerObjectNew),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //--------------------playlist add
                                        GestureDetector(
                                          onTap: () {
                                            final allbox =
                                                MusicBox.getInstance();
                                            final allSongsList =
                                                allbox.values.toList();
                                            //-------------------------------------------check current song index from allsng db
                                            int getIndexSong = allSongsList
                                                .indexWhere((element) =>
                                                    element.id ==
                                                    state
                                                        .songsList![
                                                            nowPlayingIndex
                                                                .value]
                                                        .id);

                                            showPlaylistDialog(
                                                context, getIndexSong);
                                          },
                                          child: Icon(
                                            Icons.playlist_add,
                                            size: size.width * 0.7 * 0.09,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.20,
                                        ),
                                        //---------------------------------------------------------favourites
                                        ValueListenableBuilder(
                                          valueListenable: nowPlayingIndex,
                                          builder: (context, value, child) {
                                            final nowplayBloc =
                                                context.read<NowPlayingBloc>();

                                            return IconButton(
                                              icon: BlocBuilder<FavouritesBloc,
                                                  FavouritesState>(
                                                builder: (context, state) {
                                                  //here id and song list available.
                                                  Favourites currentSong =
                                                      Favourites(
                                                          title: nowplayBloc
                                                              .state
                                                              .songsList![
                                                                  nowPlayingIndex
                                                                      .value]
                                                              .title,
                                                          artist: nowplayBloc
                                                              .state
                                                              .songsList![
                                                                  nowPlayingIndex
                                                                      .value]
                                                              .artist,
                                                          id: nowplayBloc
                                                              .state
                                                              .songsList![
                                                                  nowPlayingIndex
                                                                      .value]
                                                              .id,
                                                          uri: nowplayBloc
                                                              .state
                                                              .songsList![
                                                                  nowPlayingIndex
                                                                      .value]
                                                              .uri,
                                                          duration: nowplayBloc
                                                              .state
                                                              .songsList![
                                                                  nowPlayingIndex
                                                                      .value]
                                                              .duration);

                                                  if (state.favlist
                                                      .where((fav) =>
                                                          fav.id ==
                                                          currentSong.id)
                                                      .isEmpty) {
                                                    return Icon(
                                                        size: size.width *
                                                            0.7 *
                                                            0.09,
                                                        Icons.favorite_outline,
                                                        color: Colors.black);
                                                  } else {
                                                    return Icon(
                                                      Icons.favorite,
                                                      size: size.width *
                                                          0.7 *
                                                          0.09,
                                                      color:
                                                          const Color.fromARGB(
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
                                                        nowplayBloc
                                                            .state
                                                            .songsList![
                                                                nowPlayingIndex
                                                                    .value]
                                                            .id);
                                                // ---------------------------------------------Add to favorites
                                                if (checkFavouriteStatus(
                                                    getIndexSong)) {
                                                  BlocProvider.of<
                                                              FavouritesBloc>(
                                                          context)
                                                      .add(AddToFavourites(
                                                          getIndexSong));

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              content: Text(
                                                                'Song added to Favourites',
                                                              )));
                                                } else if (!checkFavouriteStatus(
                                                    getIndexSong)) {
                                                  //-----------------------------------------------remove fav bloc

                                                  BlocProvider.of<
                                                              FavouritesBloc>(
                                                          context)
                                                      .add(RemoveFromFavGeneral(
                                                          getIndexSong));

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
                                        //------------------------------------seekbutton
                                        GestureDetector(
                                          onTap: () {
                                            //------------------------------------------seek previous
                                            if (justAudioPlayerObjectNew
                                                .hasPrevious) {
                                              justAudioPlayerObjectNew
                                                  .seekToPrevious();
                                            }
                                          },
                                          child: Icon(
                                            Icons.skip_previous,
                                            size: size.width * 0.7 * 0.15,
                                          ),
                                        ),

                                        //-----------------------------------------play or pause button
                                        GestureDetector(
                                          onTap: () {
                                            if (justAudioPlayerObjectNew
                                                .playing) {
                                              justAudioPlayerObjectNew.pause();
                                            } else {
                                              if (justAudioPlayerObjectNew
                                                      .currentIndex !=
                                                  null) {
                                                justAudioPlayerObjectNew.play();
                                              }
                                            }
                                          },
                                          child: StreamBuilder<bool>(
                                            stream: justAudioPlayerObjectNew
                                                .playingStream,
                                            builder: (context, snapshot) {
                                              bool? playingState =
                                                  snapshot.data;

                                              if (playingState != null &&
                                                  playingState) {
                                                return CircleAvatar(
                                                  backgroundColor: Colors.black,
                                                  radius:
                                                      size.width * 0.7 * 0.1,
                                                  child: Icon(
                                                    Icons.pause,
                                                    size:
                                                        size.width * 0.7 * 0.18,
                                                  ),
                                                );
                                              }

                                              return CircleAvatar(
                                                radius: size.width * 0.7 * 0.1,
                                                backgroundColor: Colors.black,
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  size: size.width * 0.7 * 0.18,
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        //---------------------------------------seek next function
                                        GestureDetector(
                                          onTap: () {
                                            if (justAudioPlayerObjectNew
                                                .hasNext) {
                                              justAudioPlayerObjectNew
                                                  .seekToNext();
                                            }
                                          },
                                          child: Icon(
                                            Icons.skip_next,
                                            size: size.width * 0.7 * 0.15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.05,
                                    )
                                  ]))),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
