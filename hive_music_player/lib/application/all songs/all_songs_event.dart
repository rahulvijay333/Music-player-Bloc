part of 'all_songs_bloc.dart';

@immutable
abstract class AllSongsEvent {}


class OpenAllBox extends AllSongsEvent {
  
}
class GetAllSongs extends AllSongsEvent {}
