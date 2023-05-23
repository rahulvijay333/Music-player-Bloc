part of 'mostly_played_bloc.dart';

@immutable
abstract class MostlyPlayedEvent {}

class GetMostlyPlayed extends MostlyPlayedEvent {}

class UpdateMostlyPLayed extends MostlyPlayedEvent {
  final AudioModel music;
  

  UpdateMostlyPLayed(this.music,);
}

class ClearMostlyPlayed extends MostlyPlayedEvent {
  
}