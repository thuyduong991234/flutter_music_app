import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/anims/record_anim.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/download_model.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/ui/page/albums_page.dart';
import 'package:provider/provider.dart';

import '../history_search_page.dart';
import '../player_page.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tab;
  AnimationController controllerRecord;
  Animation<double> animationRecord;
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tab = new TabController(length: 3, vsync: this);
    controllerRecord = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationRecord =
        new CurvedAnimation(parent: controllerRecord, curve: Curves.linear);
    animationRecord.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerRecord.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerRecord.forward();
      }
    });
  }

  @override
  void dispose() {
    controllerRecord.dispose();
    super.dispose();
  }

  Widget _buildSongItem(Song data, {bool isDownload = false}) {
    FavoriteModel favoriteModel = Provider.of(context);
    DownloadModel downloadModel = Provider.of(context);
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
          else
            IconButton(
                onPressed: () => downloadModel.removeFile(data),
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
    super.build(context);
    FavoriteModel favoriteModel = Provider.of(context);
    DownloadModel downloadModel = Provider.of(context);
    SongModel songModel = Provider.of(context);
    if (songModel.isPlaying) {
      controllerRecord.forward();
    } else {
      controllerRecord.stop(canceled: false);
    }
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
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor.withAlpha(50),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextField(
                        readOnly: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HistorySearchPage(),
                            ),
                          );
                        },
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Theme.of(context).accentColor,
                            ),
                            hintText: songModel.songs != null
                                ? songModel.currentSong.title
                                : S.of(context).searchSuggest),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: RotateRecord(
                      animation: _commonTween.animate(controllerRecord)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("My music",
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: Theme.of(context).accentColor)),
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
                      Tab(
                          text: "Thư viện ( " +
                              favoriteModel.favoriteSong.length.toString() +
                              " )"),
                      Tab(
                          text: "Playlist ( " +
                              favoriteModel.playlists.length.toString() +
                              " )"),
                      Tab(
                          text: "Đã tải ( " +
                              downloadModel.downloadSong.length.toString() +
                              " )")
                    ],
                    labelColor: Theme.of(context).accentColor,
                    indicatorColor: Theme.of(context).accentColor,
                  ),
                ),
                body: TabBarView(
                  controller: _tab,
                  children: <Widget>[
                    ListView.builder(
                      itemCount: favoriteModel.favoriteSong.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Center(
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 90, right: 90),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black12, width: 1),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (null !=
                                          favoriteModel.favoriteSong[0].link &&
                                      favoriteModel.favoriteSong.length > 0) {
                                    SongModel songModel = Provider.of(context);
                                    songModel
                                        .setSongs(favoriteModel.favoriteSong);
                                    songModel.setCurrentIndex(0);
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.play_arrow,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Play',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        index--;
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
                      itemCount: downloadModel.downloadSong.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Center(
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 90, right: 90),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black12, width: 1),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (null !=
                                          downloadModel.downloadSong[0].link &&
                                      downloadModel.downloadSong.length > 0) {
                                    SongModel songModel = Provider.of(context);
                                    songModel
                                        .setSongs(downloadModel.downloadSong);
                                    songModel.setCurrentIndex(0);
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.play_arrow,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Play',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        index--;
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
