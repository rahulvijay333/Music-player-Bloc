import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/hive/db_functions/splash/splash_functions.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';

import '../../model/fav/fav_mode.dart';

late Box<Favourites> favouritesDbBox;

ValueNotifier<List<Favourites>> favNotifier = ValueNotifier([]);

openFavouritesDb() async {
  favouritesDbBox = await Hive.openBox<Favourites>(favBoxName);

  favNotifier.value.addAll(favouritesDbBox.values.toList());
  favNotifier.notifyListeners();
}

// add to fav from all songs page
addToFavouritesDB(int index) async {
  List<AudioModel> allsongs = box.values.toList();

  List<Favourites> favSongs = favouritesDbBox.values.toList();

  //check if song is present in fav
  bool checkFav =
      favSongs.where((song) => song.title == allsongs[index].title).isEmpty;

  if (checkFav) {
    await favouritesDbBox.add(Favourites(
        title: allsongs[index].title,
        artist: allsongs[index].artist,
        id: allsongs[index].id,
        uri: allsongs[index].uri,
        duration: allsongs[index].duration));

    await updateNotifier();
  } else {
    int songIndex =
        favSongs.indexWhere((song) => song.id == allsongs[index].id);

    await favouritesDbBox.deleteAt(songIndex);
  }
}

//check fav status before adding to fav database
bool checkFavouriteStatus(int index) {
  List<AudioModel> allsongs = box.values.toList();

  List<Favourites> favSongs = favouritesDbBox.values.toList();

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

// remove fav from all songs page
removeFromFavouritesDb(int index) async {
  List<Favourites> favsongs = favouritesDbBox.values.toList();

  List<AudioModel> allsongsDb = box.values.toList();

  int deleteIndex =
      favsongs.indexWhere((favsong) => favsong.id == allsongsDb[index].id);

  await favouritesDbBox.deleteAt(deleteIndex);
  updateNotifier();
}

//used to update favourite notifer like status update
updateNotifier() async {
  final boxfav = FavouriteBox.getinstance();
  favNotifier.value.clear();
  favNotifier.value.addAll(boxfav.values.toList());

  favNotifier.notifyListeners();
}

// delete fav from fav screen
deleteFromFavouritesDb(int id, BuildContext context) async {
  List<Favourites> favsongs = favouritesDbBox.values.toList();

  int deleteIndex = favsongs.indexWhere((favsong) => favsong.id == id);

  await favouritesDbBox.deleteAt(deleteIndex);
  updateNotifier();
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
