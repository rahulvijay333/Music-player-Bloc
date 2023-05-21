import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_music_player/hive/model/all_songs/model.dart';
import 'package:meta/meta.dart';

part 'all_songs_event.dart';
part 'all_songs_state.dart';

class AllSongsBloc extends Bloc<AllSongsEvent, AllSongsState> {
  AllSongsBloc() : super(AllSongsState.initial()) {
    on<OpenAllBox>((event, emit) async {
      await Hive.openBox<AudioModel>(musicsDbName);
    });

    on<GetAllSongs>((event, emit) {
      emit(AllSongsState(allsongs: [], loading: true));

      final songDb = MusicBox.getInstance();

      List<AudioModel> listFrmDb = songDb.values.toList();

      emit(AllSongsState(allsongs: listFrmDb, loading: false));
    });
  }
}
