part of 'now_playing_bloc.dart';

class NowPlayingState {
  final List<AudioModel>? songsList;
  final int? indexChange;

  final AudioPlayer? audioobj;

  factory NowPlayingState.initial() {
    return NowPlayingState(songsList: null, indexChange: null, audioobj: null);
  }

  NowPlayingState(
      {required this.songsList,
      required this.indexChange,
      required this.audioobj});
}
