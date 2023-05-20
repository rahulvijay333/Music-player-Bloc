import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

import '../../model/all_songs/model.dart';
import '../../model/recently_played/recently_model.dart';

late Box<RecentlyPlayed> recentlyPlayedBox;

openRecentlyPlayed() async {
  recentlyPlayedBox = await Hive.openBox<RecentlyPlayed>(recentlyDbName);
}

updateRecentPlay(RecentlyPlayed recentSong) async {
  List<RecentlyPlayed> recentList = recentlyPlayedBox.values.toList();

  bool checkSong =
      recentList.where((song) => song.title == recentSong.title).isEmpty;

  if (checkSong) {
    await recentlyPlayedBox.add(recentSong);
  } else {
    int index = recentList.indexWhere((song) => song.title == recentSong.title);

    recentlyPlayedBox.deleteAt(index);
    await recentlyPlayedBox.add(recentSong);
  }
}

deleteRecentlyPlayed(int id) async {
  List<RecentlyPlayed> recentList = recentlyPlayedBox.values.toList();

  int getSongIndex = recentList.indexWhere((element) => element.id == id);

  await recentlyPlayedBox.deleteAt(getSongIndex);
}

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
