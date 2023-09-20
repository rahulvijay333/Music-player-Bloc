part of 'now_playing_bloc.dart';

class NowPlayingEvent {}

class PlaySelectedSong extends NowPlayingEvent {
  final int? index;
  final List<AudioModel>? songs;
  final AudioPlayer audioObj;

  PlaySelectedSong({required this.index, required this.songs, required this.audioObj});

  
}
class ClearNowPlayingCall extends NowPlayingEvent {}

class PlayPauseCall extends NowPlayingEvent {}

class SeekToPreviousCall extends NowPlayingEvent {}

class SeekToNextCall extends NowPlayingEvent {}

class IntializeAudioObject extends NowPlayingEvent {
  final AudioPlayer audioObj;

  IntializeAudioObject({required this.audioObj});
}

class ChangeSong extends NowPlayingEvent {
  final int index;

  ChangeSong({required this.index});
}
