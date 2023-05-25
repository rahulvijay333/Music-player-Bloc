import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
part 'playlist_model.g.dart';

const String playlistDbName = 'Playlist';

@HiveType(typeId: 5)
class Playlist {
  @HiveField(0)
  final String? playlistName;

  @HiveField(1)
  final List<AudioModel> playlistSongs;

  Playlist({required this.playlistName, required this.playlistSongs});
}

class PlaylistBox {
  static Box<Playlist>? _box;

  static Box<Playlist> getInstance() {
    return _box ??= Hive.box(playlistDbName);
  }
}
