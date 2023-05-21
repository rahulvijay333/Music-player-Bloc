part of 'playlist_bloc.dart';

class PlaylistState {
  final List<Playlist> playlists;
  final bool loading;

  PlaylistState({required this.playlists, required this.loading});

  factory PlaylistState.intial() {
    return PlaylistState(playlists: [], loading: false);
  }
}

