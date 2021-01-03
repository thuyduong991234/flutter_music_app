import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/anims/player_anim.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/model/download_model.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/ui/page/artist_page.dart';
import 'package:flutter_music_app/ui/widget/add_to_playlist.dart';
import 'package:flutter_music_app/ui/widget/app_bar.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/ui/widget/comment_carousel.dart';
import 'package:flutter_music_app/ui/widget/lyrics.dart';
import 'package:flutter_music_app/ui/widget/player_carousel.dart';
import 'package:flutter_music_app/ui/widget/song_list_carousel.dart';
import 'package:provider/provider.dart';

class PlayPage extends StatefulWidget {
  final bool nowPlay;
  final bool isOffline;

  PlayPage({this.nowPlay, this.isOffline = false});

  @override
  _PlayPageState createState() => _PlayPageState();
}

enum enumTimer { ZERO, ONE, TWO, THREE, FOUR }

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  AnimationController controllerPlayer;
  Animation<double> animationPlayer;
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  enumTimer _timer = enumTimer.ZERO;

  @override
  initState() {
    super.initState();
    controllerPlayer = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationPlayer =
        new CurvedAnimation(parent: controllerPlayer, curve: Curves.linear);
    animationPlayer.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerPlayer.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerPlayer.forward();
      }
    });
  }

  @override
  void dispose() {
    controllerPlayer.dispose();
    super.dispose();
  }

  setTimerCountDown() {
    final cron = Cron();
    SongModel songs = Provider.of(context);
    //debugPrint("SONG TIMER2 = " + songs.timer.inMinutes.toString());
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      songs.setTimer(songs.timer - Duration(minutes: 1));
      //debugPrint("SONG TIMER = " + songs.timer.inMinutes.toString());
      if (songs.timer.inMinutes < 0 && songs.timer.inMinutes != -2) {
        //debugPrint("SONG TIMER <= " + songs.timer.inMinutes.toString());
        songs.setTimer(Duration(minutes: -1));
        songs.pause();
        await cron.close();
      } else if (songs.timer.inMinutes == -2) {
        songs.setTimer(Duration(minutes: -1));
        await cron.close();
      }
    });
  }

  _showTimerOption() {
    SongModel songModel = Provider.of(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, setState) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Container(
                        height: 200,
                        child: Wrap(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Hẹn giờ tắt",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    )),
                                Container(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      songModel.timer.inMinutes < 0
                                          ? "0 : 0'"
                                          : songModel.timer.inHours.toString() +
                                              " : " +
                                              songModel.timer.inMinutes
                                                  .toString() +
                                              "'",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Theme.of(context).accentColor),
                                    )),
                                Switch(
                                  value: songModel.timer.inMinutes > 0
                                      ? true
                                      : false,
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == false) {
                                        songModel
                                            .setTimer(Duration(minutes: -1));
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Radio(
                                    activeColor: Theme.of(context).accentColor,
                                    value: enumTimer.ONE,
                                    groupValue: _timer,
                                    onChanged: (enumTimer value) {
                                      setState(() {
                                        _timer = enumTimer.ZERO;
                                        songModel
                                            .setTimer(Duration(minutes: 15));
                                        setTimerCountDown();
                                      });

                                      Navigator.of(context).pop();
                                    }),
                                Radio(
                                    activeColor: Theme.of(context).accentColor,
                                    value: enumTimer.TWO,
                                    groupValue: _timer,
                                    onChanged: (enumTimer value) {
                                      setState(() {
                                        _timer = enumTimer.ZERO;
                                        songModel
                                            .setTimer(Duration(minutes: 30));
                                        setTimerCountDown();
                                      });
                                      Navigator.of(context).pop();
                                    }),
                                Radio(
                                    activeColor: Theme.of(context).accentColor,
                                    value: enumTimer.THREE,
                                    groupValue: _timer,
                                    onChanged: (enumTimer value) {
                                      setState(() {
                                        _timer = enumTimer.ZERO;
                                        songModel
                                            .setTimer(Duration(minutes: 60));
                                        setTimerCountDown();
                                      });
                                      Navigator.of(context).pop();
                                    }),
                                Radio(
                                    activeColor: Theme.of(context).accentColor,
                                    value: enumTimer.FOUR,
                                    groupValue: _timer,
                                    onChanged: (enumTimer value) {
                                      setState(() {
                                        _timer = enumTimer.ZERO;
                                        songModel
                                            .setTimer(Duration(minutes: 120));
                                        setTimerCountDown();
                                      });
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 10, left: 15),
                                    child: Text("15'",
                                        style: TextStyle(fontSize: 14))),
                                Container(
                                    padding: EdgeInsets.only(top: 10, left: 3),
                                    child: Text("30'",
                                        style: TextStyle(fontSize: 14))),
                                Container(
                                    padding: EdgeInsets.only(top: 10, left: 2),
                                    child: Text("60'",
                                        style: TextStyle(fontSize: 14))),
                                Container(
                                    padding: EdgeInsets.only(top: 10, right: 8),
                                    child: Text("120'",
                                        style: TextStyle(fontSize: 14))),
                              ],
                            ),
                            SizedBox(height: 50),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    )),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _showEnterTimer();
                                      },
                                      child: Text("Nhập số phút",
                                          style: TextStyle(fontSize: 14))),
                                )
                              ],
                            ),
                          ],
                        )),
                  ));
        });
  }

  _showEnterTimer() {
    SongModel songModel = Provider.of(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          int _minutes = 0;
          return StatefulBuilder(
              builder: (BuildContext context, setState) => AlertDialog(
                    content: Container(
                        height: 150,
                        child: Wrap(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Hẹn giờ tắt",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    )),
                                Container(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      songModel.timer.inMinutes < 0
                                          ? "0 : 0'"
                                          : songModel.timer.inHours.toString() +
                                              " : " +
                                              songModel.timer.inMinutes
                                                  .toString() +
                                              "'",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Theme.of(context).accentColor),
                                    )),
                                Switch(
                                  value: songModel.timer.inMinutes > 0
                                      ? true
                                      : false,
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == false) {
                                        songModel
                                            .setTimer(Duration(minutes: -1));
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                            SizedBox(height: 50),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    )),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: Text("Nhập số phút",
                                          style: TextStyle(fontSize: 14))),
                                ),
                              ],
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                setState(() {
                                  _minutes = int.parse(text);
                                });
                              },
                            ),
                          ],
                        )),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            setState(() {
                              songModel.setTimer(Duration(minutes: _minutes));
                              setTimerCountDown();
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text("ĐỒNG Ý",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor)))
                    ],
                  ));
        });
  }

  Widget buildTextArtistName(List<Artist> artists) {
    List<Widget> list = new List<Widget>();
    if (artists == null) {
      return new Expanded(child: Text("data"));
    }

    for (var i = 0; i < artists.length; i++) {
      String re = (artists[i].link.split("/")).last;
      if (i == artists.length - 1) {
        list.add(new GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArtistPage(artistAlias: re),
              ),
            );
          },
          child: Text(
            artists[i].name,
            style: TextStyle(color: Colors.grey, fontSize: 15.0),
          ),
        ));
      } else {
        list.add(new GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArtistPage(artistAlias: re),
              ),
            );
          },
          child: Text(
            artists[i].name + ", ",
            style: TextStyle(color: Colors.grey, fontSize: 15.0),
          ),
        ));
      }
    }

    return new Row(
      children: list,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    SongModel songModel = Provider.of(context);
    DownloadModel downloadModel = Provider.of(context);
    FavoriteModel favouriteModel = Provider.of(context);
    if (songModel.isPlaying) {
      controllerPlayer.forward();
    } else {
      controllerPlayer.stop(canceled: false);
    }

    //songModel.setComments();

    List<Widget> pages = [
      SongListCarousel(),
      ListView(
        children: [
          Column(
            children: <Widget>[
              AppBarCarousel(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              RotatePlayer(animation: _commonTween.animate(controllerPlayer)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => _showTimerOption(),
                      icon: songModel.timer.inMinutes < 0
                          ? Icon(
                              Icons.timer,
                              size: 25.0,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.timer,
                              size: 25.0,
                              color: Theme.of(context).accentColor,
                            ),
                    ),
                    IconButton(
                      onPressed: () => songModel.changeRepeat(),
                      icon: songModel.isRepeat == true
                          ? Icon(
                              Icons.repeat,
                              size: 25.0,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.shuffle,
                              size: 25.0,
                              color: Theme.of(context).accentColor,
                            ),
                    ),
                    AddPlayList(songModel.currentSong, favouriteModel),
                    IconButton(
                      onPressed: () =>
                          downloadModel.download(songModel.currentSong),
                      icon: downloadModel.isDownload(songModel.currentSong)
                          ? Icon(
                              Icons.cloud_done,
                              size: 25.0,
                              color: Theme.of(context).accentColor,
                            )
                          : Icon(
                              Icons.cloud_download,
                              size: 25.0,
                              color: Colors.grey,
                            ),
                    ),
                    CommentCarousel()
                  ]),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              buildTextArtistName(songModel.currentSong.artists),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                songModel.currentSong.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          )
        ],
      ),
      SongLyricsCarousel(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: PageView(
                    children: pages,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    controller: PageController(
                      initialPage: 1,
                    ))),
            Player(
                songData: songModel,
                downloadData: downloadModel,
                nowPlay: widget.nowPlay,
                isOffline: widget.isOffline),
          ],
        ),
      ),
    );
  }
}
