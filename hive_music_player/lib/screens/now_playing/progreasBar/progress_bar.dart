import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive_music_player/screens/miniPlayer/mini_player.dart';
import 'package:rxdart/rxdart.dart';

class CustomProgressBar extends StatefulWidget {
  const CustomProgressBar({super.key});

  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  //combine duration to class obj for progress bar
  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          justAudioPlayerObject.positionStream,
          justAudioPlayerObject.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: StreamBuilder<DurationState>(
        stream: _durationStateStream,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.position ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;

          return ProgressBar(
            progress: progress,
            total: total,
            barHeight: 8,
            progressBarColor: Colors.black,
            thumbColor: Colors.black,
            onSeek: (duration) {
              justAudioPlayerObject.seek(duration);
            },
          );
        },
      ),
    );
  }
}

class DurationState {
  Duration position, total;

  DurationState({this.position = Duration.zero, this.total = Duration.zero});
}
