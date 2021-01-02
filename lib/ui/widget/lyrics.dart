import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_util.dart';
import 'package:flutter_lyric/lyric_widget.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:provider/provider.dart';

class SongLyricsCarousel extends StatefulWidget {
  @override
  _ForYouCarouselState createState() => _ForYouCarouselState();
}

class _ForYouCarouselState extends State<SongLyricsCarousel>
    with TickerProviderStateMixin {
  Timer _countdownTimer;
  int _countdownNum = 3000000;
  Duration start = new Duration(seconds: 0);
  SongModel songModel;
  @override
  void initState() {
    if (_countdownTimer != null) {
      return;
    }
    _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (songModel != null && songModel.lyric != null) {
        //debugPrint("POSITION: " + songModel.position.inSeconds.toString());
        start = new Duration(seconds: 0) +
            new Duration(seconds: songModel.position.inSeconds);
        //debugPrint("DURATION: " + start.toString());
      }
      if (this.songModel != null &&
          songModel.isPlaying &&
          songModel.lyric != null) {
        setState(() {
          _countdownNum--;
          start = start + new Duration(seconds: 1);
          if (_countdownNum == 0) {
            _countdownTimer.cancel();
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    songModel = Provider.of(context);
    //debugPrint("Lyric: " + songLyc);
    var lyrics =
        songModel.lyric != null ? LyricUtil.formatLyric(songModel.lyric) : null;
    //debugPrint("LYRIC: " + songModel.lyric);
    return Scaffold(
      body: Center(
          child: songModel.lyric != null
              ? LyricWidget(
                  size: Size(400, 600),
                  lyrics: lyrics,
                  vsync: this,
                  currLyricStyle: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 20),
                  currentProgress: start.inMilliseconds.toDouble(),
                )
              : Text("Chưa có lời bài hát!")),
    );
  }
}
