import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:hive_music_player/hive/model/playlist/playlist_model.dart';
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

bool checkPlaylistName(String name) {
  final list = [];
  final box2 = PlaylistBox.getInstance();

  final playlist = box2.values.toList();

  for (int i = 0; i < box2.length; i++) {
    list.add(playlist[i].playlistName);
  }

  if (list.contains(name)) {
    return true;
  } else {
    return false;
  }
  
}