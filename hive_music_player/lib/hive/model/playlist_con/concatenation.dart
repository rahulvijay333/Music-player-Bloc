import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:just_audio/just_audio.dart';

class SongConcatencation {
  static ConcatenatingAudioSource createPlaylist(List<AudioModel> songs) {
    List<AudioSource> sources = [];

    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }
}
