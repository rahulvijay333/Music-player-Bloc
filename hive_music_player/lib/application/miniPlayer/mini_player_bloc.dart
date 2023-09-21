import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rythem_rider/domain/model/all_songs/model.dart';

part 'mini_player_event.dart';
part 'mini_player_state.dart';

class MiniPlayerBloc extends Bloc<MiniPlayerEvent, MiniPlayerState> {
  MiniPlayerBloc() : super(MiniPlayerState.intial()) {
    on<ShowMiniPLayer>((event, emit) {
      emit(MiniPlayerState(event.playinglist, true, state.index));
    });
    on<CloseMiniPlayer>((event, emit) {
      emit(MiniPlayerState(state.playingList, false, state.index));
    });

    on<UpdateMiniIndex>((event, emit) {
      log('${event.index} changed update');
      emit(MiniPlayerState(state.playingList, state.showPlayer, event.index));
    });
  }
}
