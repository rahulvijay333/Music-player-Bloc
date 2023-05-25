import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';

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

  Favourites({
    required this.title,
    required this.artist,
    required this.id,
    required this.uri,
    required this.duration,
  });
}

class FavouriteBox {
  static Box<Favourites>? _box;

  static Box<Favourites> getinstance() {
    return _box ??= Hive.box(favBoxName);
  }
}

// used to convert fav model class to audio model class
List<AudioModel> convertToAudioModel(List<Favourites> favlist) {
  List<AudioModel> audiolist = [];

  for (var song in favlist) {
    audiolist.add(AudioModel(
        title: song.title,
        artist: song.artist,
        id: song.id,
        uri: song.uri,
        duration: song.duration));
  }

  return audiolist;
}

//check fav status before adding to fav database
bool checkFavouriteStatus(int index) {
  final alldb = MusicBox.getInstance();
  final favdb = FavouriteBox.getinstance();
  List<AudioModel> allsongs = alldb.values.toList();

  List<Favourites> favSongs = favdb.values.toList();

  Favourites favSong = Favourites(
      title: allsongs[index].title,
      artist: allsongs[index].artist,
      id: allsongs[index].id,
      uri: allsongs[index].uri,
      duration: allsongs[index].duration);

  bool checkFavSongPresent =
      favSongs.where((fav) => fav.id == favSong.id).isEmpty;

  return checkFavSongPresent ? true : false;
}
