import 'package:flutter/material.dart';
import 'package:shevarms_user/shared/shared.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String fileUrl;
  const AudioPlayerWidget(this.fileUrl);

  @override
  State<StatefulWidget> createState() {
    return _AudioPlayerWidgetState();
  }
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late MyAudioPlayer player;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    player = MyAudioPlayer(setState, durationUpdate);
    super.initState();
  }

  void durationUpdate(Duration d) {
    setState(() {
      _duration = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: 75,
        height: 75,
        child: Stack(
          children: [
            player.playing && player.duration != null
                ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 70,
                value: _duration.inSeconds / player.duration!.inSeconds,
              ),
            )
                : const SizedBox(),
            ColorIconButton(
              '',
              (player.playing ? Icons.pause : Icons.play_arrow),
              Colors.white,
              onPressed: () async {
                if (player.playing) {
                  player.pause();
                } else {
                  player.play(widget.fileUrl);
                }
              },
              borderColor: AppColors.primaryColor,
              iconColor: AppColors.primaryColor,
              iconSize: 40,
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Text(StringUtils.durationToString(_duration))
    ]);
  }
}
