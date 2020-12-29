import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/service/base_repository.dart';
import 'package:flutter_music_app/ui/widget/app_bar.dart';

class ArtistPage extends StatefulWidget {
  final String artisAlias;

  ArtistPage({this.artisAlias});

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
    var artist = await BaseRepository.fetchArtist("sontungmtp");
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
                child: Text(this.data.name),
              )
            ],
          ))
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
