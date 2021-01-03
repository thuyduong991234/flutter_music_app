import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/ui/page/albums_page.dart';
import 'package:flutter_music_app/ui/page/artist_page.dart';
import 'package:provider/provider.dart';

class CircleArtistsCarousel extends StatefulWidget {
  final List<Artist> artists;
  final String title;

  CircleArtistsCarousel(this.artists, this.title);
  @override
  _CircleArtistsCarouselState createState() => _CircleArtistsCarouselState();
}

class _CircleArtistsCarouselState extends State<CircleArtistsCarousel> {
  String alias;
  String isFollowed;

  @override
  Widget build(BuildContext context) {
    FavoriteModel favoriteModel = Provider.of(context);
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
                widget.title == "Spotlight"
                    ? "Spotlight"
                    : (widget.title == "Nghe si cong hien"
                        ? "Nghệ sĩ đóng góp"
                        : "Bạn có thể thích"),
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
          ],
        ),
      ),
      Column(
        children: <Widget>[
          Container(
            height: 250,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.artists.length,
              itemBuilder: (BuildContext context, int index) {
                Artist data = widget.artists[index];
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArtistPage(
                          artistAlias: (data.link.split("/")).last,
                        ),
                      ),
                    ),
                  },
                  child: Container(
                    width: 140,
                    margin: index == widget.artists.length - 1
                        ? EdgeInsets.only(right: 20.0)
                        : EdgeInsets.only(right: 0.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(90.0),
                            child: Image(
                              height: 120.0,
                              width: 120.0,
                              image: CachedNetworkImageProvider(data.thumbnail),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              data.name,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (data.follow != null)
                            Center(
                              child: Text(
                                data.follow.toString() + " quan tâm",
                                style: TextStyle(
                                  fontSize: 10.0,
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
                                  top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black12
                                        : Colors.grey[500],
                                    width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: GestureDetector(
                                  onTap: () {
                                    if (favoriteModel.followArtists
                                            .contains(data) ==
                                        false)
                                      favoriteModel.addArtist(data);
                                    else
                                      favoriteModel.removeArtist(data);
                                  },
                                  child: favoriteModel.followArtists != null
                                      ? (favoriteModel.followArtists
                                                  .contains(data) ==
                                              false
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(Icons.person_add,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    size: 20),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Quan tâm",
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "Đã quan tâm",
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                ),
                                              ],
                                            ))
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.person_add,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                size: 20),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Quan tâm",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            ),
                                          ],
                                        )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )
    ]);
  }
}
