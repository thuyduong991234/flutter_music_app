import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/service/base_repository.dart';
import 'package:flutter_music_app/ui/widget/albums_carousel.dart';
import 'package:flutter_music_app/ui/widget/app_bar.dart';
import 'package:flutter_music_app/ui/widget/circle_artist_carousel.dart';
import 'package:flutter_music_app/ui/widget/list_artists_carousel.dart';
import 'package:flutter_music_app/ui/widget/short_song_carousel.dart';

class ArtistPage extends StatefulWidget {
  final String artistAlias;

  ArtistPage({this.artistAlias});

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  Artist data;

  @override
  void initState() {
    super.initState();
    fetchArtist();
  }

  void fetchArtist() async {
    var artist = await BaseRepository.fetchArtist(widget.artistAlias);
    setState(() {
      data = artist;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.data != null) {
      return Scaffold(
          body: SafeArea(
        child: Column(children: <Widget>[
          AppBarCarousel(),
          Expanded(
              child: ListView(
            children: <Widget>[
              Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(this.data.thumbnail))),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(this.data.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0)),
                ),
              ),
              Center(
                child: Text(
                  data.follow.toString() + " quan tâm",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  height: 30,
                  margin: EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 120.0, right: 120.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.person_add,
                            color: Theme.of(context).accentColor, size: 20),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Quan tâm',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).accentColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ShortSongCarousel(this.data.songs, "Top bài hát", true, false,
                  null, this.data.id),
              AlbumsCarousel(this.data.albums, false, false, false, null),
              CircleArtistsCarousel(this.data.relatedArtists)
            ],
          )),
        ]),
      ));
    }

    return Scaffold(
      body: SafeArea(
        child: Center(child: Text("đang tải...")),
      ),
    );
  }
}
