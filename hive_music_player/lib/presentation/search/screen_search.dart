import 'package:flutter/material.dart';
import 'package:hive_music_player/common/common.dart';
import 'package:hive_music_player/domain/db_functions/splash/splash_functions.dart';
import 'package:hive_music_player/domain/model/all_songs/model.dart';

import 'widget/search_tile.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key});

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  final allSongBoxList = box.values.toList();

  List<AudioModel> searchList = [];

  @override
  void initState() {
    setState(() {
      searchList = allSongBoxList;
    });
    super.initState();
  }

  //function that returns list of matching keyword
  onchangeSearch(String songName) {
    setState(() {
      searchList = allSongBoxList
          .where((song) => song.title!.toLowerCase().contains(songName))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: mainColor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: mainColor,
            title: const Text('Search Songs'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  //----------------------------------search value function
                  onChanged: (value) {
                    onchangeSearch(value);
                  },

                  //--------------------------------------------------
                  style: const TextStyle(color: Colors.white), autofocus: true,

                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          )),
                      hintText: 'Search Here....',
                      hintStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.transparent.withOpacity(0.3),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ))),
                ),
                const SizedBox(
                  height: 20,
                ),
                searchList.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return SearchTileWidget(
                                songName: searchList[index].title!,
                                artistName: searchList[index].artist!,
                                audioList: searchList,
                                index: index,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: searchList.length),
                      )
                    : const Expanded(
                        child: SizedBox(
                          // color: Colors.red,
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: Text(
                              'No Search Results',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
