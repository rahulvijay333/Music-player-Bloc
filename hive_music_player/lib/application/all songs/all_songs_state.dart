part of 'all_songs_bloc.dart';

 class AllSongsState {

  final List<AudioModel> allsongs;
  final bool loading;

  AllSongsState({required this.allsongs,required this.loading});

  factory AllSongsState.initial(){
    return AllSongsState(allsongs: [], loading: false);
  }
  
 }


