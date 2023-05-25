import 'package:bloc/bloc.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
import 'package:hive_music_player/domain/model/mostply_played/mosltly_played_model.dart';
import 'package:meta/meta.dart';

part 'mostly_played_event.dart';
part 'mostly_played_state.dart';



class MostlyPlayedBloc extends Bloc<MostlyPlayedEvent, MostlyPlayedState> {
  MostlyPlayedBloc() : super(MostlyPlayedState.initial()) {
    on<GetMostlyPlayed>((event, emit) {
      emit(MostlyPlayedState([], true));
      final mostlyDb = MostplePlayedBox.getInstance();

      final mostlyPlayedList = mostlyDb.values.toList();

      emit(MostlyPlayedState(mostlyPlayedList, false));
    });

    on<UpdateMostlyPLayed>((event, emit) {
      final musicUpdate = convertToMostplyedModel(event.music);

      final mostlyBox = MostplePlayedBox.getInstance();

      List<MostlyPlayed> mostlyPlayedDbList = mostlyBox.values.toList();

      bool check =
          mostlyPlayedDbList.where((song) => song.id == event.music.id).isEmpty;

      if (check) {
        mostlyBox.add(musicUpdate);
      } else {
        int getMusicIndex =
            mostlyPlayedDbList.indexWhere((song) => song.id == musicUpdate.id);

        int count = mostlyPlayedDbList[getMusicIndex].count;

        mostlyBox.deleteAt(getMusicIndex);
        musicUpdate.count = count + 1;
        mostlyBox.add(musicUpdate);
      }
      add(GetMostlyPlayed());
    });

    on<ClearMostlyPlayed>((event, emit) async {
      final box6 = MostplePlayedBox.getInstance();

      await box6.clear();
    });
  }
}
