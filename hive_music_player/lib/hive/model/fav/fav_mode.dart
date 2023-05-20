import 'package:hive_flutter/hive_flutter.dart';

part 'fav_mode.g.dart';

String favBoxName = 'favourites';

@HiveType(typeId: 2)
class Favourites {
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

  Favourites(
   { required  this.title,
   required this.artist,
   required this.id,
   required this.uri,
   required this.duration,}
  );
}

class FavouriteBox {
  static Box<Favourites>? _box;

  static Box<Favourites> getinstance() {
    return _box ??= Hive.box(favBoxName);
  }
}
