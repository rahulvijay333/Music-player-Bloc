part of 'mini_player_bloc.dart';

 class MiniPlayerState {

  final List<AudioModel> playingList;
  final bool showPlayer;
  final int index;

  MiniPlayerState(this.playingList, this.showPlayer, this.index);

  factory MiniPlayerState.intial(){
    return MiniPlayerState([], false,0);
  }

 }


