import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_music_player/application/favourites/favourites_bloc.dart';
import 'package:hive_music_player/application/miniPlayer/mini_player_bloc.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/presentation/miniPlayer/mini_player.dart';
import 'widgets/favourite_tile.dart';

class ScreenFavourtites extends StatelessWidget {
  const ScreenFavourtites({super.key});

  @override
  Widget build(BuildContext context) {
    //------------------------------------------------fav bloc here
    BlocProvider.of<FavouritesBloc>(context).add(GetFavouritesSongs());
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
            builder: (context, state) {
              if (state.showPlayer == false) {
                return const SizedBox();
              }
              return const MiniPlayer();
            },
          ),
          appBar: AppBar(
            title: const Text('Favourites'),
            centerTitle: true,
            backgroundColor: mainColor,
          ),
          backgroundColor: mainColor,
          //-------------------------------------------------------------bloc fav
          body: BlocBuilder<FavouritesBloc, FavouritesState>(
            builder: (context, state) {
              if (state.favlist.isEmpty) {
                return const Center(
                  child: Text(
                    'No Favourites',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FavouriteTileCustom(
                              songName: state.favlist[index].title!,
                              index: index,
                              id: state.favlist[index].id!,
                              size: size,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 2,
                            );
                          },
                          itemCount: state.favlist.length),
                    ));
              }
            },
          )),
    );
  }
}
