part of 'mini_player_bloc.dart';

@immutable
abstract class MiniPlayerEvent {}

class ShowMiniPLayer extends MiniPlayerEvent {
  final List<AudioModel> playinglist;
  final int index;
  

  ShowMiniPLayer(this.playinglist, this.index);
}

class CloseMiniPlayer extends MiniPlayerEvent {}

class UpdateMiniIndex extends MiniPlayerEvent {
  final int index;

  UpdateMiniIndex(this.index);
}
