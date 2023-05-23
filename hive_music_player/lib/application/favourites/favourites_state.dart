part of 'favourites_bloc.dart';

 class FavouritesState {

  final List<Favourites> favlist;
  final bool loading;

  FavouritesState(this.favlist, this.loading);

  factory FavouritesState.initial(){
    return FavouritesState([], false);
  }
 }


