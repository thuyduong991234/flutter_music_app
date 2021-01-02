import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/helper/refresh_helper.dart';
import 'package:flutter_music_app/ui/page/albums_page.dart';
import 'package:flutter_music_app/ui/page/player_page.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'add_to_playlist.dart';

class ListSongCarousel extends StatefulWidget {
  final String input;
  final String type;
  final bool isAlbum;
  ListSongCarousel({this.input, this.type, this.isAlbum});
  @override
  _ListSongCarouselState createState() => _ListSongCarouselState();
}

class _ListSongCarouselState extends State<ListSongCarousel> {
  Widget _buildSongItem(Song data) {
    FavoriteModel favoriteModel = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
                width: 50,
                height: 50,
                child:
                    Image(image: CachedNetworkImageProvider(data.thumbnail))),
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
                            color: Colors.grey,
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
    return ProviderWidget<ListSongModel>(
        onModelReady: (model) async {
          await model.initData();
        },
        model: ListSongModel(input: widget.input, type: widget.type),
        builder: (context, model, child) {
          if (model.busy) {
            return ViewStateBusyWidget();
          } else if (model.error && model.list.isEmpty) {
            return ViewStateErrorWidget(
                error: model.viewStateError, onPressed: model.initData);
          }
          var songs = model?.songs ?? [];
          return SmartRefresher(
            controller: model.refreshController,
            header: WaterDropHeader(),
            footer: RefresherFooter(),
            onRefresh: () async {
              await model.refresh();
            },
            onLoading: () async {
              await model.loadMore();
            },
            enablePullUp: true,
            child: ListView.builder(
              shrinkWrap: true, //解决无限高度问题
              //physics: new NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                Song data = songs[index];
                return GestureDetector(
                  onTap: () {
                    if (!widget.isAlbum) {
                      if (null != data.link) {
                        SongModel songModel = Provider.of(context);
                        songModel.setSongs(new List<Song>.from(songs));
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
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AlbumsPage(
                            data: data,
                          ),
                        ),
                      );
                    }
                  },
                  child: _buildSongItem(data),
                );
              },
            ),
          );
        });
  }
}
