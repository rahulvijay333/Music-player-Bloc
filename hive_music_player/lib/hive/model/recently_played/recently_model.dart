import 'package:hive_flutter/hive_flutter.dart';
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
