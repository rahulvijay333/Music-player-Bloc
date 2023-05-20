import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:on_audio_query/on_audio_query.dart';

final audioquery = OnAudioQuery();

final box = MusicBox.getInstance();

List<SongModel> querySongs = [];

getStoragePermissionInitialMethod() async {
  bool permissionCheck = await audioquery.permissionsStatus();

  if (!permissionCheck) {
    await audioquery.permissionsRequest();

    querySongs = await audioquery.querySongs();

    for (var song in querySongs) {
      box.add(AudioModel(
          title: song.title,
          artist: song.artist,
          id: song.id,
          uri: song.uri,
          duration: song.duration));
    }
  }
}

refreshDatabaseFunction() async {
  querySongs = await audioquery.querySongs();

  for (var song in querySongs) {
    box.add(AudioModel(
        title: song.title,
        artist: song.artist,
        id: song.id,
        uri: song.uri,
        duration: song.duration));
  }
}

refreshAllSongs() async {
  await box.clear();

  querySongs = await audioquery.querySongs();

  for (var song in querySongs) {
    box.add(AudioModel(
        title: song.title,
        artist: song.artist,
        id: song.id,
        uri: song.uri,
        duration: song.duration));
  }
}
