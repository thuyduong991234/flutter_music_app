import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:provider/provider.dart';

import 'add_to_playlist.dart';

class SongListCarousel extends StatefulWidget {
  @override
  _ForYouCarouselState createState() => _ForYouCarouselState();
}

class _ForYouCarouselState extends State<SongListCarousel> {
  Widget _buildSongItem(Song data) {
    FavoriteModel favoriteModel = Provider.of(context);
    SongModel songModel = Provider.of(context);
    return data.id == songModel.currentSong.id
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                padding: EdgeInsets.all(10),
                color: Theme.of(context).accentColor.withAlpha(90),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                          width: 50,
                          height: 50,
                          child: Image.network(data.thumbnail)),
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
                                      color: Colors.grey,
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
                                      color: Colors.grey,
                                    )
                                  : TextStyle(
                                      fontSize: 10.0,
                                    ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                    ),
                    IconButton(
                        onPressed: () => favoriteModel.collect(data),
                        icon: Icon(
                          Icons.pause,
                          size: 20.0,
                        ))
                  ],
                ),
              ),
            ),
          )
        : Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                      width: 50,
                      height: 50,
                      child: Image.network(data.thumbnail)),
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
                                  color: Colors.grey,
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
                                  color: Colors.grey,
                                )
                              : TextStyle(
                                  fontSize: 10.0,
                                ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                ),
                AddPlayList(data, favoriteModel)
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    SongModel songModel = Provider.of(context);
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: songModel.songs.length,
        itemBuilder: (BuildContext context, int index) {
          Song data = songModel.songs[index];
          return GestureDetector(
            onTap: () {
              if (null != data.link) {
                songModel.setCurrentIndex(index);
                songModel.setPlayNow(true);
                Future.delayed(new Duration(milliseconds: 100), () {
                  songModel.setPlayNow(false);
                });
              }
            },
            child: _buildSongItem(data),
          );
        },
      ),
    );
  }
}
