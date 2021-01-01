import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/service/base_repository.dart';
import 'package:flutter_music_app/ui/widget/albums_carousel.dart';
import 'package:flutter_music_app/ui/widget/app_bar.dart';
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
                  padding: EdgeInsets.all(16.0),
                  child: Text(this.data.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              ShortSongCarousel(this.data.songs, "Top bài hát", true, false,
                  null, this.data.id),
              AlbumsCarousel(this.data.albums, false, true, null),
              ListArtistsCarousel(this.data.relatedArtists, true, null)
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
