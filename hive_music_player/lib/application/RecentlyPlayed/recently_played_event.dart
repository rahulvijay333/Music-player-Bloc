part of 'recently_played_bloc.dart';

@immutable
abstract class RecentlyPlayedEvent {}

class GetRecentlyPlayed extends RecentlyPlayedEvent {}

class UpdateRecentlyplayed extends RecentlyPlayedEvent {
  final RecentlyPlayed recentSong;

  UpdateRecentlyplayed({required this.recentSong});
}

class DeleteRecentlyPlayed extends RecentlyPlayedEvent {
  final int id;

  DeleteRecentlyPlayed({required this.id});
}
