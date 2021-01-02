import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/page/artist_page.dart';
import 'package:flutter_music_app/ui/page/player_page.dart';
import 'package:flutter_music_app/ui/widget/album_carousel.dart';
import 'package:flutter_music_app/ui/widget/album_playlist_carousel.dart';
import 'package:flutter_music_app/ui/widget/app_bar.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/ui/widget/circle_artist_carousel.dart';
import 'package:flutter_music_app/ui/widget/for_you_carousel.dart';
import 'package:provider/provider.dart';

class AlbumsPage extends StatefulWidget {
  final Song data;
  final bool isAlbum;
  final bool isPlaylist;
  final String data2;

  AlbumsPage(
      {this.data, this.isAlbum = false, this.isPlaylist = false, this.data2});

  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
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

    return new Wrap(
      children: list,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      spacing: 5.0,
      runSpacing: 10.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isAlbum) {
      return Scaffold(
          body: SafeArea(
              child: ProviderWidget<SongListModel>(
                  onModelReady: (model) async {
                    await model.initData();
                  },
                  model: SongListModel(
                      input: widget.data.id, isAlbum: widget.data.isAlbum),
                  builder: (context, model, child) {
                    if (model.busy) {
                      return ViewStateBusyWidget();
                    } else if (model.error && model.list.isEmpty) {
                      return ViewStateErrorWidget(
                          error: model.viewStateError,
                          onPressed: model.initData);
                    }
                    var songs = model?.song ?? [];
                    var sections = model?.sections ?? [];
                    var participants = model?.artists ?? [];
                    return Column(
                      children: <Widget>[
                        AppBarCarousel(),
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              Center(
                                  child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.width * 0.5,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Container(
                                        child: Image.network(
                                            widget.data.thumbnail))),
                              )),
                              SizedBox(height: 15.0),
                              Center(
                                child: Text(
                                  widget.data.title,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Center(
                                child: buildTextArtistName(widget.data.artists),
                              ),
                              Center(
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 90, right: 90),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black12, width: 1),
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (null != songs[0].link) {
                                        SongModel songModel =
                                            Provider.of(context);
                                        Random r = new Random();
                                        songModel.setSongs(songs);
                                        songModel.setCurrentIndex(
                                            r.nextInt(songs.length));
                                        songModel.setRepeat(false);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PlayPage(
                                              nowPlay: true,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.play_arrow,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Play',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AlbumCarousel(
                                input: widget.data.id,
                                isAlbum: widget.data.isAlbum,
                              ),
                              sections.length > 0
                                  ? ForYouCarousel(
                                      sections, "take care", false, false, null)
                                  : Text(""),
                              participants.length > 0
                                  ? CircleArtistsCarousel(participants)
                                  : Text("")
                            ],
                          ),
                        ),
                      ],
                    );
                  })));
    }

    if (widget.isPlaylist) {
      return Scaffold(
          body: SafeArea(
              child: ProviderWidget<PlaylistSongModel>(
                  onModelReady: (model) async {
                    await model.initData();
                  },
                  model: PlaylistSongModel(name: widget.data2),
                  builder: (context, model, child) {
                    if (model.busy) {
                      return ViewStateBusyWidget();
                    } else if (model.error && model.list.isEmpty) {
                      return ViewStateErrorWidget(
                          error: model.viewStateError,
                          onPressed: model.initData);
                    }
                    FavoriteModel f = Provider.of(context);
                    var songs = f.playlists[model.name];
                    int idx = songs.length;

                    return Column(
                      children: <Widget>[
                        AppBarCarousel(),
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              Center(
                                  child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withAlpha(30),
                                    ),
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      '$idx',
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ))),
                              )),
                              SizedBox(height: 15.0),
                              Center(
                                child: Text(
                                  widget.data2,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Center(
                                child: Text("Author"),
                              ),
                              Center(
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 90, right: 90),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black12, width: 1),
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (null != songs[0].link) {
                                        SongModel songModel =
                                            Provider.of(context);
                                        Random r = new Random();
                                        songs = songs is List<dynamic> ? SongCollection.cast(songs) : songs;
                                        songModel.setSongs(songs);
                                        songModel.setCurrentIndex(
                                            r.nextInt(songs.length));
                                        songModel.setRepeat(false);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PlayPage(
                                              nowPlay: true,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.play_arrow,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Play',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AlbumPlaylistCarousel(name: widget.data2),
                            ],
                          ),
                        ),
                      ],
                    );
                  })));
    }

    return Text("none");
  }
}
