import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/page/player_page.dart';
import 'package:provider/provider.dart';

class AlbumPlaylistCarousel extends StatefulWidget {
  final String name;

  AlbumPlaylistCarousel({this.name});

  @override
  _AlbumPlaylistCarouselState createState() => _AlbumPlaylistCarouselState();
}

class _AlbumPlaylistCarouselState extends State<AlbumPlaylistCarousel> {
  Widget _buildSongItem(Song data, int index) {
    FavoriteModel favoriteModel = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor.withAlpha(30),
                ),
                width: 50,
                height: 50,
                child: Center(
                    child: Text(
                  '$index',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ))),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.title,
                    style: data.link == null
                        ? TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE0E0E0),
                          )
                        : TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.artistName,
                    style: data.link == null
                        ? TextStyle(
                            fontSize: 10.0,
                            color: Color(0xFFE0E0E0),
                          )
                        : TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                          ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
          IconButton(
              onPressed: () => favoriteModel.collect2(widget.name, data),
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).accentColor,
                size: 20.0,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<PlaylistSongModel>(
        onModelReady: (model) async {
          await model.initData();
        },
        model: PlaylistSongModel(name: widget.name),
        builder: (context, model, child) {
          if (model.busy) {
            return ViewStateBusyWidget();
          } else if (model.error && model.list.isEmpty) {
            return ViewStateErrorWidget(
                error: model.viewStateError, onPressed: model.initData);
          }
          FavoriteModel favoriteModel = Provider.of(context);
          var songs = favoriteModel.playlists[model.name];
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              //解决无限高度问题
              physics: new NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                Song data = songs[index];
                return GestureDetector(
                  onTap: () {
                    if (null != data.link) {
                      SongModel songModel = Provider.of(context);
                      songModel.setSongs(SongCollection.cast(songs));
                      songModel.setCurrentIndex(index);
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
                  child: _buildSongItem(data, index + 1),
                );
              },
            ),
          );
        });
  }
}
