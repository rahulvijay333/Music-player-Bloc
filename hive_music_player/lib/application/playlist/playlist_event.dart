part of 'playlist_bloc.dart';

@immutable
abstract class PlaylistEvent {}

class GetAllPlaylist extends PlaylistEvent {}

class CreatePlaylist extends PlaylistEvent {
  final String name;

  CreatePlaylist(this.name);
}

class EditPlaylist extends PlaylistEvent {
  final String name;
  final int index;

  EditPlaylist({required this.name,required this.index});
}

class DeletePlaylist extends PlaylistEvent {

  final int index;

  DeletePlaylist(this.index);
}

class AddToPlaylist extends PlaylistEvent {

  final int playlistIndex;
  final int songIndex;
  final BuildContext context;

  AddToPlaylist(this.playlistIndex, this.songIndex, this.context);

}

class DeleteFromPlaylist extends PlaylistEvent {
  final int playlistIndex;
  final int songIndex;

  DeleteFromPlaylist(this.playlistIndex, this.songIndex);
  
}

class ViewPlaylistSongs extends PlaylistEvent {
  final int index;

  ViewPlaylistSongs({required this.index});
}
