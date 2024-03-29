import 'package:rythem_rider/domain/model/all_songs/model.dart';
import 'package:on_audio_query/on_audio_query.dart';

final audioquery = OnAudioQuery();

final box = MusicBox.getInstance();

List<SongModel> querySongs = [];

getStoragePermissionInitialMethod() async {
  bool permissionCheck = await audioquery.permissionsStatus();
  // bool checkpermission = await audioquery.checkAndRequest();

  if (!permissionCheck) {
    await audioquery.permissionsRequest();

    final List<AudioModel> songslist = [];
    querySongs = await audioquery.querySongs();

    for (var song in querySongs) {
      final songFromDevice = AudioModel(
          title: song.title,
          artist: song.artist,
          id: song.id,
          uri: song.uri,
          duration: song.duration);

      if (!songslist.contains(songFromDevice)) {
        songslist.add(songFromDevice);
        box.add(AudioModel(
            title: song.title,
            artist: song.artist,
            id: song.id,
            uri: song.uri,
            duration: song.duration));
      }
    }
  }
}

refreshDatabaseFunction() async {
  querySongs = await audioquery.querySongs();

 final List<AudioModel> songslist = [];
    // querySongs = await audioquery.querySongs();

    for (var song in querySongs) {
      final songFromDevice = AudioModel(
          title: song.title,
          artist: song.artist,
          id: song.id,
          uri: song.uri,
          duration: song.duration);

      if (!songslist.contains(songFromDevice)) {
        songslist.add(songFromDevice);
        box.add(AudioModel(
            title: song.title,
            artist: song.artist,
            id: song.id,
            uri: song.uri,
            duration: song.duration));
      }
    }
}

refreshAllSongs() async {
  await box.clear();

 final List<AudioModel> songslist = [];
    querySongs = await audioquery.querySongs();

    for (var song in querySongs) {
      final songFromDevice = AudioModel(
          title: song.title,
          artist: song.artist,
          id: song.id,
          uri: song.uri,
          duration: song.duration);

      if (!songslist.contains(songFromDevice)) {
        songslist.add(songFromDevice);
        box.add(AudioModel(
            title: song.title,
            artist: song.artist,
            id: song.id,
            uri: song.uri,
            duration: song.duration));
      }
    }
}
