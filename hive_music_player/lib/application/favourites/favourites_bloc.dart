import 'package:bloc/bloc.dart';
import 'package:hive_music_player/domain/db_functions/splash/splash_functions.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';
import 'package:hive_music_player/domain/model/fav/fav_mode.dart';
import 'package:meta/meta.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  FavouritesBloc() : super(FavouritesState.initial()) {
    on<GetFavouritesSongs>((event, emit) {
      emit(FavouritesState([], true));

     
      final favdb = FavouriteBox.getinstance();

      final favlist = favdb.values.toList();

      emit(FavouritesState(favlist, false));
    });

    on<AddToFavourites>((event, emit) async {
      final favdb = FavouriteBox.getinstance();
      List<AudioModel> allsongs = box.values.toList();

      List<Favourites> favSongs = favdb.values.toList();

      //check if song is present in fav
      bool checkFav = favSongs
          .where((song) => song.title == allsongs[event.index].title)
          .isEmpty;

      if (checkFav) {
        await favdb.add(Favourites(
            title: allsongs[event.index].title,
            artist: allsongs[event.index].artist,
            id: allsongs[event.index].id,
            uri: allsongs[event.index].uri,
            duration: allsongs[event.index].duration));
      } else {
        int songIndex =
            favSongs.indexWhere((song) => song.id == allsongs[event.index].id);

        await favdb.deleteAt(songIndex);
      }
      add(GetFavouritesSongs());
    });

    on<DeleteFromFavourites>((event, emit) async {
      final favdb = FavouriteBox.getinstance();
      List<Favourites> favsongs = favdb.values.toList();

      int deleteIndex =
          favsongs.indexWhere((favsong) => favsong.id == event.index);

      await favdb.deleteAt(deleteIndex);

      add(GetFavouritesSongs());
    });

    on<RemoveFromFavGeneral>((event, emit) async {
      final favdb = FavouriteBox.getinstance();

      List<Favourites> favsongs = favdb.values.toList();

      List<AudioModel> allsongsDb = box.values.toList();

      int deleteIndex = favsongs
          .indexWhere((favsong) => favsong.id == allsongsDb[event.index].id);

      await favdb.deleteAt(deleteIndex);
      add(GetFavouritesSongs());
    });

    // add(GetFavouritesSongs());
  }
}
