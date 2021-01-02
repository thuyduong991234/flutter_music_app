import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/download_model.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/ui/page/albums_page.dart';
import 'package:provider/provider.dart';

import '../player_page.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tab;

  @override
  bool get wantKeepAlive => true;

  Widget _buildSongItem(Song data, {bool isDownload = false}) {
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
          if (isDownload == false)
            IconButton(
                onPressed: () => favoriteModel.collect(data),
                icon: data.link == null
                    ? Icon(
                        Icons.favorite_border,
                        color: Color(0xFFE0E0E0),
                        size: 20.0,
                      )
                    : favoriteModel.isCollect(data)
                        ? Icon(
                            Icons.favorite,
                            color: Theme.of(context).accentColor,
                            size: 20.0,
                          )
                        : Icon(
                            Icons.favorite_border,
                            size: 20.0,
                          ))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tab = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    FavoriteModel favoriteModel = Provider.of(context);
    DownloadModel downloadModel = Provider.of(context);
    //downloadModel.refresh();
    //favoriteModel.refresh();
    debugPrint(
        "DOWNLOAD----------" + downloadModel.downloadSong.length.toString());
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(S.of(context).favourites,
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
          ),
          Expanded(
            child: DefaultTabController(
              length: _tab.length,
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 50,
                  backgroundColor: Colors.white,
                  bottom: TabBar(
                    controller: _tab,
                    tabs: [
                      Tab(text: "Thư viện"),
                      Tab(text: "Danh sách phát"),
                      Tab(text: "Đã tải")
                    ],
                    labelColor: Theme.of(context).accentColor,
                    indicatorColor: Theme.of(context).accentColor,
                  ),
                ),
                body: TabBarView(
                  controller: _tab,
                  children: <Widget>[
                    ListView.builder(
                      itemCount: favoriteModel.favoriteSong.length,
                      itemBuilder: (BuildContext context, int index) {
                        Song data = favoriteModel.favoriteSong[index];
                        return GestureDetector(
                          onTap: () {
                            if (null != data.link) {
                              SongModel songModel = Provider.of(context);
                              songModel.setSongs(new List<Song>.from(
                                  favoriteModel.favoriteSong));
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
                          child: _buildSongItem(data),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: favoriteModel.playlists.keys.length,
                      itemBuilder: (BuildContext context, int index) {
                        String data =
                            favoriteModel.playlists.keys.elementAt(index);
                        int ix = favoriteModel.playlists[data].length;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AlbumsPage(
                                    isPlaylist: true,
                                    isAlbum: false,
                                    data2: data),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
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
                                        '$ix',
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          data,
                                          style: data == null
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
                                          "Author",
                                          style: data == null
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
                                    onPressed: () =>
                                        favoriteModel.removePlaylist(data),
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Theme.of(context).accentColor,
                                      size: 20.0,
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: downloadModel.downloadSong.length,
                      itemBuilder: (BuildContext context, int index) {
                        Song data = downloadModel.downloadSong[index];
                        return GestureDetector(
                          onTap: () {
                            if (null != data.link) {
                              SongModel songModel = Provider.of(context);
                              songModel.setSongs(new List<Song>.from(
                                  downloadModel.downloadSong));
                              songModel.setCurrentIndex(index);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PlayPage(nowPlay: true, isOffline: true),
                                ),
                              );
                            }
                          },
                          child: _buildSongItem(data, isDownload: true),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
