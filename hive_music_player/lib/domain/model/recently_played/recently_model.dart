import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
part 'recently_model.g.dart';

String recentlyDbName = 'RecentlyPlayed';

@HiveType(typeId: 3)
class RecentlyPlayed {
  @HiveField(0)
  final String? title;

  @HiveField(1)
  final String? artist;

  @HiveField(2)
  final int? id;

  @HiveField(3)
  final String? uri;

  @HiveField(4)
  final int? duration;

  RecentlyPlayed(this.title, this.artist, this.id, this.uri, this.duration);
}

class RecentlyPlayedBox {
  static Box<RecentlyPlayed>? _box;

  static Box<RecentlyPlayed> getinstance() {
    return _box ??= Hive.box(recentlyDbName);
  }
}

//use to convert recentlyplayed object to audio model before sending to playing screen.
List<AudioModel> convertRecentlyPlayedToAudioModel(
    List<RecentlyPlayed> recentlyList) {
  List<AudioModel> audioList = [];

  for (var song in recentlyList) {
    audioList.add(AudioModel(
        title: song.title,
        artist: song.artist,
        id: song.id,
        uri: song.uri,
        duration: song.duration));
  }
  return audioList;
}

