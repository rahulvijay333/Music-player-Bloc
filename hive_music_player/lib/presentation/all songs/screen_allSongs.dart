import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rythem_rider/application/all%20songs/all_songs_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rythem_rider/application/favourites/favourites_bloc.dart';
import 'package:rythem_rider/application/now_playing/bloc/now_playing_bloc.dart';
import 'package:rythem_rider/common/common.dart';
import 'package:rythem_rider/common/widgets/app_bar_custom.dart';

import 'package:rythem_rider/domain/model/all_songs/model.dart';
import 'package:rythem_rider/presentation/all%20songs/widgets/tile_all_songs.dart';
import 'package:rythem_rider/presentation/home/screen_home.dart';
import 'package:rythem_rider/presentation/now_playing/screen_now_playing.dart';
import 'package:rythem_rider/presentation/search/screen_search.dart';

class ScreenAllSongs extends StatelessWidget {
  ScreenAllSongs({
    super.key,
  });

  final songDb = MusicBox.getInstance();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    BlocProvider.of<FavouritesBloc>(context).add(GetFavouritesSongs());

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
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Column(
              children: [
                CustomAppBar(
                    size: size,
                    heading: 'All Songs',
                    twoItems: true,
                    widgetLeft: IconButton(
                        onPressed: () {
                          //
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                    widgetRight: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return const ScreenSearch();
                            },
                          ));
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ))),
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: BlocBuilder<AllSongsBloc, AllSongsState>(
                      builder: (context, state) {
                        return Container(
                          height: size.height * 0.82,
                          width: double.maxFinite,
                          child: state.allsongs.isNotEmpty
                              ? Container(
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                  child: CupertinoScrollbar(
                                    controller: scrollController,
                                    thumbVisibility: true,
                                    child: ListView.separated(
                                        controller: scrollController,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: AllSongTileWidget(
                                              songlist: state.allsongs,
                                              index: index,
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 5,
                                          );
                                        },
                                        itemCount: state.allsongs.length),
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'No Songs',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        );
                      },
                    )
                    //---------------------------------------show when No songs available

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
                            child: BlocBuilder<NowPlayingBloc, NowPlayingState>(
                              builder: (context, state) {
                                return ScreenNowPlaying(
                                  songs: state.songsList!,
                                );
                              },
                            ));
                      },
                    ));
              },
            )
          ],
        ),
      ),
    ));
  }
}

class Appbarcustom extends StatelessWidget {
  const Appbarcustom({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: size.height * 0.07,
          width: size.width,
          child: const Center(
              child: Text(
            'All songs',
            style: TextStyle(color: Colors.white),
          )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const ScreenSearch();
                    },
                  ));
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ],
        )
      ],
    );
  }
}
