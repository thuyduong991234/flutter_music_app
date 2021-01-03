import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/helper/refresh_helper.dart';
import 'package:flutter_music_app/ui/page/albums_page.dart';
import 'package:flutter_music_app/ui/page/artist_page.dart';
import 'package:flutter_music_app/ui/page/player_page.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchArtistCarousel extends StatefulWidget {
  final String input;
  SearchArtistCarousel({this.input});
  @override
  _SearchArtistCarouselState createState() => _SearchArtistCarouselState();
}

class _SearchArtistCarouselState extends State<SearchArtistCarousel> {
  Widget _buildSongItem(Artist data) {
    FavoriteModel favoriteModel = Provider.of(context);
    bool isFollowed = false;
    if (favoriteModel.followArtists != null) {
      for (int i = 0; i < favoriteModel.followArtists.length; i++) {
        if (favoriteModel.followArtists[i].id == data.id) {
          isFollowed = true;
          break;
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(90.0),
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
                    data.name,
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
                ]),
          ),
          IconButton(
              onPressed: () {
                isFollowed == false
                    ? favoriteModel.addArtist(data)
                    : favoriteModel.removeArtist(data);
              },
              icon: Icon(
                Icons.person_add,
                color: isFollowed == true
                    ? Theme.of(context).accentColor
                    : Colors.grey,
                size: 20.0,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<ListArtistModel>(
        onModelReady: (model) async {
          await model.initData();
        },
        model: ListArtistModel(input: widget.input),
        builder: (context, model, child) {
          if (model.busy) {
            return ViewStateBusyWidget();
          } else if (model.error && model.list.isEmpty) {
            return ViewStateErrorWidget(
                error: model.viewStateError, onPressed: model.initData);
          }
          var artists = model?.artists ?? [];
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
              scrollDirection: Axis.vertical,
              itemCount: artists.length,
              itemBuilder: (BuildContext context, int index) {
                Artist data = artists[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArtistPage(
                          artistAlias: (data.link.split("/")).last,
                        ),
                      ),
                    );
                  },
                  child: _buildSongItem(data),
                );
              },
            ),
          );
        });
  }
}
