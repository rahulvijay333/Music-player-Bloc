import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/hive/db_functions/splash/splash_functions.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';

import '../../model/playlist/playlist_model.dart';

// late Box<Playlist> playListBox;

// ValueNotifier<List<Playlist>> playlistNotifier = ValueNotifier([]);

// openPlaylistDb() async {
//   playListBox = await Hive.openBox<Playlist>(playlistDbName);
//   updatePlaylistNotifier();
// }

//-----------------------------------create playlist

// createPlaylist(String playlistName) async {
//   final box = PlaylistBox.getInstance();

//   List<AudioModel> playlistSongs = [];

//   await box
//       .add(Playlist(playlistName: playlistName, playlistSongs: playlistSongs));

//   updatePlaylistNotifier();
// }

// //-------------------------------edit playlist function

// editPlayList({required String name, required int index}) {
//   //-----------------------------------------------------------call db object
//   final playBox = PlaylistBox.getInstance();
//   //-----------------------------------------------------------get list from db
//   final getlistFromDb = playBox.values.toList();

//   playBox.putAt(
//       index,
//       Playlist(
//           playlistName: name,
//           playlistSongs: getlistFromDb[index].playlistSongs));

//   updatePlaylistNotifier();
// }

// //---------------------------------delete playlist

// deletePlaylist(int index) async {
//   final box1 = PlaylistBox.getInstance();

//   await box1.deleteAt(index);
//   updatePlaylistNotifier();
// }

// //---------------------------------add to playlist : get playlist index and song index, context for snackbar

// addToPlaylist(
//     {required int playlistIndex,
//     required int songIndex,
//     required BuildContext context}) async {
//   //all song db
//   final allsongdbObj = MusicBox.getInstance();
//   List<AudioModel> allSongDb = allsongdbObj.values.toList();

//   //playlist db
//   final box2 = PlaylistBox.getInstance();
//   List<Playlist> playListDb = box2.values.toList();

//   Playlist? playlist = box2.getAt(playlistIndex);
//   List<AudioModel> playSongs = playlist!.playlistSongs;

//   bool checkSong =
//       playSongs.any((element) => element.id == allSongDb[songIndex].id);

//   //if song not present , add to list first not to db directly
//   if (!checkSong) {
//     playSongs.add(AudioModel(
//         title: allSongDb[songIndex].title,
//         artist: allSongDb[songIndex].artist,
//         id: allSongDb[songIndex].id,
//         uri: allSongDb[songIndex].uri,
//         duration: allSongDb[songIndex].duration));

//     //update playlist database
//     await box2.putAt(
//         playlistIndex,
//         Playlist(
//             playlistName: playListDb[playlistIndex].playlistName,
//             playlistSongs: playSongs));

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         duration: Duration(seconds: 1),
//         content:
//             Text('Song added to ${playListDb[playlistIndex].playlistName}')));
//   }

//   if (checkSong) {
//     final indexToDelete = playSongs
//         .indexWhere((element) => element.id == allSongDb[songIndex].id);
//     playSongs.removeAt(indexToDelete);

//     await box2.putAt(
//         playlistIndex,
//         Playlist(
//             playlistName: playlist.playlistName, playlistSongs: playSongs));

//     updatePlaylistNotifier();

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         duration: Duration(seconds: 1),
//         content: Text(
//             'Song removed removed from playlist ${playListDb[playlistIndex].playlistName}')));
//   }

//   updatePlaylistNotifier();
// }

//delete songs from db

// deleteSongFromPlaylist(
//     {required int playListIndex, required int songIndex}) async {
//   final box5 = PlaylistBox.getInstance();

//   //get current playlist using index
//   Playlist? playlist = box5.getAt(playListIndex);

//   List<AudioModel> playSongs = playlist!.playlistSongs;

//   //remove that song
//   playSongs.removeAt(songIndex);

//   //update list
//   await box5.putAt(playListIndex,
//       Playlist(playlistName: playlist.playlistName, playlistSongs: playSongs));
//   updatePlaylistNotifier();
// }

//updatePlaylistNotifier

// updatePlaylistNotifier() {
//   playlistNotifier.value.clear();

//   final playlistbox = PlaylistBox.getInstance();

//   playlistNotifier.value.addAll(playlistbox.values.toList());
//   playlistNotifier.notifyListeners();
// }

// bool checkPlaylistName(String name) {
//   final list = [];
//   final box2 = PlaylistBox.getInstance();

//   final playlist = box2.values.toList();

//   for (int i = 0; i < box2.length; i++) {
//     list.add(playlist[i].playlistName);
//   }

//   if (list.contains(name)) {
//     return true;
//   } else {
//     return false;
//   }
  
// }
