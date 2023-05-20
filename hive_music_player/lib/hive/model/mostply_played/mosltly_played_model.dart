import 'package:hive_flutter/hive_flutter.dart';
part 'mosltly_played_model.g.dart';

String mostlyPlayedDbName = 'Mostly_Played';

@HiveType(typeId: 4)
class MostlyPlayed {
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

  @HiveField(5)
   int count;

  MostlyPlayed(
      {required this.title,
      required this.artist,
      required this.id,
      required this.uri,
      required this.duration,
      this.count =0});
}

class MostplePlayedBox {
  static Box<MostlyPlayed>? _box;
  static Box<MostlyPlayed> getInstance(){
    return _box ??= Hive.box(mostlyPlayedDbName);
  }
}
