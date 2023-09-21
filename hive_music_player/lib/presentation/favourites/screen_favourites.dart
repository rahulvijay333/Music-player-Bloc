import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rythem_rider/application/favourites/favourites_bloc.dart';
import 'package:rythem_rider/application/now_playing/bloc/now_playing_bloc.dart';
import 'package:rythem_rider/common/common.dart';
import 'package:rythem_rider/common/widgets/app_bar_custom.dart';
import 'package:rythem_rider/presentation/home/screen_home.dart';
import 'package:rythem_rider/presentation/now_playing/screen_now_playing.dart';
import 'widgets/favourite_tile.dart';

class ScreenFavourtites extends StatelessWidget {
  ScreenFavourtites({super.key});
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //------------------------------------------------fav bloc here
    BlocProvider.of<FavouritesBloc>(context).add(GetFavouritesSongs());
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (showingMiniPlayer.value == false) {
            showingMiniPlayer.value = true;
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
            backgroundColor: mainColor,
            //-------------------------------------------------------------bloc fav
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    CustomAppBar(size: size, heading: 'Favourites'),
                    Expanded(
                      child: BlocBuilder<FavouritesBloc, FavouritesState>(
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
                                  child: CupertinoScrollbar(
                                      controller: scrollController,
                                      thumbVisibility: true,
                                    child: ListView.separated(
                                        controller: scrollController,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: FavouriteTileCustom(
                                              songName:
                                                  state.favlist[index].title!,
                                              index: index,
                                              id: state.favlist[index].id!,
                                              size: size,
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 2,
                                          );
                                        },
                                        itemCount: state.favlist.length),
                                  ),
                                ));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: miniPlayerActive,
                  builder: (context, isActive, child) {
                    return Visibility(
                        visible: isActive,
                        child: ValueListenableBuilder(
                          valueListenable: showingMiniPlayer,
                          builder: (context, value, child) {
                            return Positioned(
                                bottom: 0, // Adjust the position as needed
                                left: 0,
                                right: 0,
                                top: showingMiniPlayer.value ? null : 0,
                                child: BlocBuilder<NowPlayingBloc,
                                    NowPlayingState>(
                                  builder: (context, state) {
                                    return  ScreenNowPlaying(songs: state.songsList!,);
                                  },
                                ));
                          },
                        ));
                  },
                )
              ],
            )),
      ),
    );
  }
}
