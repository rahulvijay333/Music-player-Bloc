import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:hive_music_player/hive/model/all_songs/model.dart';

import '../../model/mostply_played/mosltly_played_model.dart';

// mostlyplayed Db object declaration
late Box<MostlyPlayed> mostlyPlayedDbBox;

//open mostlyplayed Db from main function
openMostlyPlayedDb() async {
  mostlyPlayedDbBox = await Hive.openBox<MostlyPlayed>(mostlyPlayedDbName);
}

updateMostlyPlayedDB(AudioModel music) {
  final musicUpdate = convertToMostplyedModel(music);

  final mostlyBox = MostplePlayedBox.getInstance();

  List<MostlyPlayed> mostlyPlayedDbList = mostlyPlayedDbBox.values.toList();

  bool check = mostlyPlayedDbList.where((song) => song.id == music.id).isEmpty;

  if (check) {
    mostlyBox.add(musicUpdate);
  } else {
    int getMusicIndex =
        mostlyPlayedDbList.indexWhere((song) => song.id == musicUpdate.id);

    int count = mostlyPlayedDbList[getMusicIndex].count;

    mostlyBox.deleteAt(getMusicIndex);
    musicUpdate.count = count + 1;
    mostlyBox.add(musicUpdate);
  }
}

//clear songs
clearSongsFromMostlyPlayed(BuildContext context) async {
  final box6 = MostplePlayedBox.getInstance();

  await box6.clear();

  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('MostlyPlayed Songs Cleared')));
}

MostlyPlayed convertToMostplyedModel(AudioModel song) {
  final MostlyPlayed music;

  music = MostlyPlayed(
      title: song.title,
      artist: song.artist,
      id: song.id,
      uri: song.uri,
      duration: song.duration);

  return music;
}

List<AudioModel> convertMostlyPlayedToAudioModelList(
    List<MostlyPlayed> songList) {
  List<AudioModel> audioList = [];

  for (var audio in songList) {
    audioList.add(AudioModel(
        title: audio.title,
        artist: audio.artist,
        id: audio.id,
        uri: audio.uri,
        duration: audio.duration));
  }

  return audioList;
}
