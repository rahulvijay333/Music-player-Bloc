part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesEvent {}

class GetFavouritesSongs extends FavouritesEvent {}

class AddToFavourites extends FavouritesEvent {
  final int index;

  AddToFavourites(this.index);
}

class DeleteFromFavourites extends FavouritesEvent {
  final int index;

  DeleteFromFavourites(this.index);
}

class RemoveFromFavGeneral extends FavouritesEvent {
  final int index;

  RemoveFromFavGeneral(this.index);
  
}
