import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/ui/page/albums_page.dart';
import 'package:flutter_music_app/ui/page/artist_page.dart';
import 'package:flutter_music_app/ui/page/history_search_page.dart';
import 'package:flutter_music_app/ui/page/player_page.dart';
import 'package:provider/provider.dart';

class ListArtistsCarousel extends StatefulWidget {
  final List<Artist> artists;
  final bool viewAll;
  final Function(int) callback;

  ListArtistsCarousel(this.artists, this.viewAll, this.callback);
  @override
  _ListArtistsCarouselState createState() => _ListArtistsCarouselState();
}

class _ListArtistsCarouselState extends State<ListArtistsCarousel> {
  Widget _buildSongItem(Artist data) {
    FavoriteModel favoriteModel = Provider.of(context);
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
              onPressed: () => {},
              icon: Icon(
                Icons.person_add,
                color: Colors.grey,
                size: 20.0,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(S.of(context).artists,
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
            widget.viewAll == true
                ? GestureDetector(
                    onTap: () => {widget.callback(3)},
                    child: Text(S.of(context).viewAll,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        )),
                  )
                : GestureDetector(
                    onTap: () => {
                      print('View All'),
                    },
                    child: Text("",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
          ],
        ),
      ),
      ListView.builder(
        shrinkWrap: true, //解决无限高度问题
        physics: new NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.artists.length,
        itemBuilder: (BuildContext context, int index) {
          Artist data = widget.artists[index];
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
    ]);
  }
}
