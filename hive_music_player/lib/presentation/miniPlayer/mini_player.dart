import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/miniPlayer/mini_player_bloc.dart';

import 'package:hive_music_player/presentation/now_playing/screen_now_playing_mini.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

final justAudioPlayerObject = AudioPlayer();


class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    //------------------------------------------mini player bottom
    return BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.transparent.withOpacity(0.5),
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
                      id: state.playingList[state.index].id!,
                      type: ArtworkType.AUDIO),
                  const SizedBox(
                    width: 5,
                  ),

                  Expanded(
                      child: GestureDetector(
                          onTap: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ScreenNowPlaying1();
                              },
                            ));
                          },
                          child: Text(
                            state.playingList[state.index].title!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ))),

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
                      size: 30,
                      color: Colors.white,
                    ),
                  ),

                  //-----------------------------------------play or pause button
                  GestureDetector(
                    onTap: () async {
                      if (justAudioPlayerObject.playing) {
                        await justAudioPlayerObject.pause();
                      } else {
                        if (justAudioPlayerObject.currentIndex != null) {
                          justAudioPlayerObject.play();
                        }
                      }
                    },
                    child: StreamBuilder<bool>(
                      stream: justAudioPlayerObject.playingStream,
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
                      if (justAudioPlayerObject.hasNext) {
                        justAudioPlayerObject.seekToNext();
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
                        BlocProvider.of<MiniPlayerBloc>(context)
                            .add(CloseMiniPlayer());

                        justAudioPlayerObject.pause();
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
      },
    );
  }
}
