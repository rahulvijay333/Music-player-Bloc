import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
import 'package:hive_music_player/domain/model/recently_played/recently_model.dart';
import 'package:meta/meta.dart';

part 'recently_played_event.dart';
part 'recently_played_state.dart';

class RecentlyPlayedBloc
    extends Bloc<RecentlyPlayedEvent, RecentlyPlayedState> {
  RecentlyPlayedBloc() : super(RecentlyPlayedState.initial()) {
    on<GetRecentlyPlayed>((event, emit) {
      emit(RecentlyPlayedState(recentList: [], loading: true));

      // db instance
      final recentDB = RecentlyPlayedBox.getinstance();

      List<RecentlyPlayed> recentList = recentDB.values.toList();

      final recentToAudioConverted =
          convertRecentlyPlayedToAudioModel(recentList.reversed.toList());

      //display to ui
      emit(RecentlyPlayedState(
          recentList: recentToAudioConverted, loading: false));
      
    });

    on<UpdateRecentlyplayed>((event, emit) async {
      final recentDB = RecentlyPlayedBox.getinstance();

      List<RecentlyPlayed> recentList = recentDB.values.toList();

      bool checkSong = recentList
          .where((song) => song.title == event.recentSong.title)
          .isEmpty;

      if (checkSong) {
        await recentDB.add(event.recentSong);
      } else {
        int index = recentList
            .indexWhere((song) => song.title == event.recentSong.title);

        recentDB.deleteAt(index);
        await recentDB.add(event.recentSong);
      }
      add(GetRecentlyPlayed());
    });

    on<DeleteRecentlyPlayed>((event, emit) async {
      final recentDB = RecentlyPlayedBox.getinstance();

      List<RecentlyPlayed> recentList = recentDB.values.toList();

      int getSongIndex =
          recentList.indexWhere((element) => element.id == event.id);

      if (getSongIndex != -1) {
        await recentDB.deleteAt(getSongIndex);
      } else {
        log('id error');
      }

      add(GetRecentlyPlayed());
    });
  }
}
