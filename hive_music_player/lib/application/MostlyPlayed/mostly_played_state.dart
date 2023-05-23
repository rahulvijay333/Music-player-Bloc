part of 'mostly_played_bloc.dart';

 class MostlyPlayedState {

  final List<MostlyPlayed> mostlyList;
  final bool loading;

  MostlyPlayedState(this.mostlyList, this.loading);

  factory MostlyPlayedState.initial(){
    return MostlyPlayedState([], false);
  }

 }


