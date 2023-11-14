import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rythem_rider/application/MostlyPlayed/mostly_played_bloc.dart';
import 'package:rythem_rider/application/RecentlyPlayed/recently_played_bloc.dart';
import 'package:rythem_rider/application/all%20songs/all_songs_bloc.dart';
import 'package:rythem_rider/application/now_playing/bloc/now_playing_bloc.dart';
import 'package:rythem_rider/common/common.dart';
import 'package:rythem_rider/common/widgets/app_bar_custom.dart';
import 'package:rythem_rider/common/widgets/menu_tile.dart';
import 'package:rythem_rider/domain/db_functions/splash/splash_functions.dart';
import 'package:rythem_rider/domain/model/recently_played/recently_model.dart';
import 'package:rythem_rider/presentation/all%20songs/screen_allSongs.dart';
import 'package:rythem_rider/presentation/favourites/screen_favourites.dart';
import 'package:rythem_rider/presentation/mostly_played/screen_mostlyPlayed.dart';
import 'package:rythem_rider/presentation/now_playing/screen_now_playing.dart';
import 'package:rythem_rider/presentation/playlists/screen/screen_playlits.dart';
import 'package:rythem_rider/presentation/settings/screen_settings.dart';
import 'package:just_audio/just_audio.dart';

import 'widgets/recentlyPlayed_tile.dart';

ValueNotifier<int> nowPlayingIndex = ValueNotifier(0);
final AudioPlayer justAudioPlayerObjectNew = AudioPlayer();

ValueNotifier<bool> showingMiniPlayer = ValueNotifier(false);
ValueNotifier<bool> miniPlayerActive = ValueNotifier(false);

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  void initState() {
    BlocProvider.of<NowPlayingBloc>(context)
        .add(IntializeAudioObject(audioObj: justAudioPlayerObjectNew));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //-------------------------------------------------recently bloc

    BlocProvider.of<RecentlyPlayedBloc>(context).add(GetRecentlyPlayed());

    return SafeArea(
      child: Scaffold(
        backgroundColor: mainColor,
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Column(
              children: [
                CustomAppBar(
                  size: size,
                  heading: 'RythemRider',
                  twoItems: true,
                  widgetLeft: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return const ScreenSettings();
                            },
                          ));
                        },
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 28,
                        )),
                  ),
                  widgetRight: IconButton(
                      onPressed: () async {
                        await refreshAllSongs();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                margin: EdgeInsetsDirectional.all(15),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 1),
                                content: Text('Songs Refreshed')));
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // /color: Colors.red,
                          width: double.infinity,
                          height: size.height * 0.35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //----------------------------row playlist and favouruties
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (ctx1) {
                                            return ScreenPlaylists();
                                          },
                                        ));
                                      },
                                      child: MenuTileWidget(
                                        categoryName: 'PlayList',
                                        size: size,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //--------------------favourites
                                  GestureDetector(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (ctx1) {
                                            return ScreenFavourtites();
                                          },
                                        ));
                                      },
                                      child: MenuTileWidget(
                                        categoryName: 'Favourites',
                                        size: size,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              //--------------------------------most played and all songs
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<MostlyPlayedBloc>(context)
                                          .add(GetMostlyPlayed());
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return const ScreenMostlyPlayed();
                                        },
                                      ));
                                    },
                                    child: MenuTileWidget(
                                      categoryName: 'Most Played',
                                      size: size,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //----------------------all
                                  GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<AllSongsBloc>(context)
                                            .add(GetAllSongs());
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (ctx1) {
                                            return ScreenAllSongs();
                                          },
                                        ));
                                      },
                                      child: MenuTileWidget(
                                        categoryName: 'All Songs',
                                        size: size,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'Recently Played',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        //---------------------------------------------recently played

                        Expanded(child: BlocBuilder<RecentlyPlayedBloc,
                            RecentlyPlayedState>(
                          builder: (context, state) {
                            if (state.recentList.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No Recently Played Songs',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else {
                              return GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 10,
                                        crossAxisCount: 3),
                                itemCount: state.recentList.length > 9
                                    ? 9
                                    : state.recentList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      final recentSong = RecentlyPlayed(
                                          state.recentList[index].title,
                                          state.recentList[index].artist,
                                          state.recentList[index].id,
                                          state.recentList[index].uri,
                                          state.recentList[index].duration);

                                      //---------------------------------------------------------------------->>recently played bloc
                                      BlocProvider.of<RecentlyPlayedBloc>(
                                              context)
                                          .add(UpdateRecentlyplayed(
                                              recentSong: recentSong));
                                      //----------------------------------------------------------------------->>mostly played bloc

                                      BlocProvider.of<MostlyPlayedBloc>(context)
                                          .add(UpdateMostlyPLayed(
                                              state.recentList[index]));
                                      //-----------------------------------------------------

                                      //---<<<<-------------------------------------------------------------------latest update
                                      context.read<NowPlayingBloc>().add(
                                          PlaySelectedSong(
                                              index: index,
                                              songs: state.recentList,
                                              audioObj:
                                                  justAudioPlayerObjectNew));

                                      nowPlayingIndex.value = index;
                                      nowPlayingIndex.notifyListeners();
                                      miniPlayerActive.value = true;
                                      showingMiniPlayer.value = false;
                                    },
                                    onDoubleTap: () async {
                                      // ------------------------------------------------delete bloc recently played song
                                      BlocProvider.of<RecentlyPlayedBloc>(
                                              context)
                                          .add(DeleteRecentlyPlayed(
                                              id: state.recentList[index].id!));
                                    },
                                    child: RecentlyPlayedCustomTile(
                                        songName:
                                            state.recentList[index].title!,
                                        artistName:
                                            state.recentList[index].artist!,
                                        list: state.recentList,
                                        index: index),
                                  );
                                },
                              );
                            }
                          },
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
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
    );
  }
}
