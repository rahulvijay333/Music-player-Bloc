import 'package:hive_flutter/hive_flutter.dart';
    part 'model.g.dart';


String musicsDbName = 'all_songs';

@HiveType(typeId: 1)
class AudioModel {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? artist;

  @HiveField(2)
  int? id;

  @HiveField(3)
  String? uri;

  @HiveField(4)
  int? duration;

  @HiveField(5)
  String? imageUrl;

  AudioModel(
      {required this.title,
      required this.artist,
      required this.id,
      required this.uri,
      required this.duration,
      this.imageUrl});
}

class MusicBox {
  static Box<AudioModel>? _box;

  static Box<AudioModel> getInstance() {
    return _box ??= Hive.box(musicsDbName);
  }
}
