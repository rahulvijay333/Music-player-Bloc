import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
import 'package:just_audio/just_audio.dart';

part 'now_playing_event.dart';
part 'now_playing_state.dart';

class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  NowPlayingBloc() : super(NowPlayingState.initial()) {
    ConcatenatingAudioSource createPlaylist(List<AudioModel> songs) {
      List<AudioSource> sources = [];

      for (var song in songs) {
        sources.add(AudioSource.uri(Uri.parse(song.uri!)));
      }
      return ConcatenatingAudioSource(children: sources);
    }

    on<IntializeAudioObject>((event, emit) {
      emit(NowPlayingState(
          songsList: state.songsList,
          indexChange: state.indexChange,
          audioobj: event.audioObj));
    });
//-----------------------------------------

    on<PlaySelectedSong>((event, emit) async {
      emit(NowPlayingState(
          songsList: event.songs,
          indexChange: event.index,
          audioobj: state.audioobj));
      await event.audioObj.setAudioSource(createPlaylist(event.songs!),
          initialIndex: event.index);

      await event.audioObj.play();

      log('songs list updated');
    });

    on<ClearNowPlayingCall>((event, emit) {
      emit(NowPlayingState(songsList: [], indexChange: null, audioobj: null));
    });
  }
}
