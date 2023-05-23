part of 'recently_played_bloc.dart';

class RecentlyPlayedState {

  final List<AudioModel> recentList;
  final bool loading ;

  RecentlyPlayedState({required this.recentList,required this.loading});

  factory RecentlyPlayedState.initial() {
    return RecentlyPlayedState(recentList: [], loading: false);
  }
  

}
