import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
import 'package:hive_music_player/domain/model/playlist/playlist_model.dart';
import 'package:meta/meta.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(PlaylistState.intial()) {
    //get playlist
    on<GetAllPlaylist>((event, emit) {
      emit(PlaylistState(playlists: [], loading: true));
      final playlistbx = PlaylistBox.getInstance();

      final list = playlistbx.values.toList();

      emit(PlaylistState(playlists: list, loading: false));
    });

    //----------------------------------------------------------create Playlist
    on<CreatePlaylist>((event, emit) async {
      final box = PlaylistBox.getInstance();

      List<AudioModel> playlistSongs = [];

      await box.add(
          Playlist(playlistName: event.name, playlistSongs: playlistSongs));

      add(GetAllPlaylist());
    });

    //--------------------------------------------------------edit playlist
    on<EditPlaylist>((event, emit) {
      final playBox = PlaylistBox.getInstance();
      //-get list from db
      final getlistFromDb = playBox.values.toList();

      playBox.putAt(
          event.index,
          Playlist(
              playlistName: event.name,
              playlistSongs: getlistFromDb[event.index].playlistSongs));

      add(GetAllPlaylist());
    });

    //-------------------------------------------------------delete
    on<DeletePlaylist>((event, emit) async {
      final box1 = PlaylistBox.getInstance();

      await box1.deleteAt(event.index);
      add(GetAllPlaylist());
    });

    //-------------------------------------------------------add songs to playlist
    on<AddToPlaylist>((event, emit) async {
      //all song db
      final allsongdbObj = MusicBox.getInstance();
      List<AudioModel> allSongDb = allsongdbObj.values.toList();

      //playlist db
      final box2 = PlaylistBox.getInstance();
      List<Playlist> playListDb = box2.values.toList();

      Playlist? playlist = box2.getAt(event.playlistIndex);
      List<AudioModel> playSongs = playlist!.playlistSongs;

      bool checkSong = playSongs
          .any((element) => element.id == allSongDb[event.songIndex].id);

      //if song not present , add to list first not to db directly
      if (!checkSong) {
        playSongs.add(AudioModel(
            title: allSongDb[event.songIndex].title,
            artist: allSongDb[event.songIndex].artist,
            id: allSongDb[event.songIndex].id,
            uri: allSongDb[event.songIndex].uri,
            duration: allSongDb[event.songIndex].duration));

        //update playlist database
        await box2.putAt(
            event.playlistIndex,
            Playlist(
                playlistName: playListDb[event.playlistIndex].playlistName,
                playlistSongs: playSongs));

                ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content:
            Text('Song added to ${playListDb[event.playlistIndex].playlistName}')));
      }

      if (checkSong) {
        final indexToDelete = playSongs.indexWhere(
            (element) => element.id == allSongDb[event.songIndex].id);
        playSongs.removeAt(indexToDelete);

        await box2.putAt(
            event.playlistIndex,
            Playlist(
                playlistName: playlist.playlistName, playlistSongs: playSongs));


                ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content:
            Text('song removed from ${playListDb[event.playlistIndex].playlistName}')));
      }

      add(GetAllPlaylist());
    });

    //delete song from playlist
    on<DeleteFromPlaylist>((event, emit) async {
      final box5 = PlaylistBox.getInstance();

      //get current playlist using index
      Playlist? playlist = box5.getAt(event.playlistIndex);

      List<AudioModel> playSongs = playlist!.playlistSongs;

      //remove that song
      playSongs.removeAt(event.songIndex);

      //update list
      await box5.putAt(
          event.playlistIndex,
          Playlist(
              playlistName: playlist.playlistName, playlistSongs: playSongs));


      add(GetAllPlaylist());

    });
  }
}
