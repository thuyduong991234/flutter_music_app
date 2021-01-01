import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/model/home_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/widget/albums_carousel.dart';
import 'package:flutter_music_app/anims/record_anim.dart';
import 'package:flutter_music_app/ui/widget/for_you_carousel.dart';
import 'package:flutter_music_app/ui/page/search_page.dart';
import 'package:flutter_music_app/ui/widget/list_artists_carousel.dart';
import 'package:flutter_music_app/ui/widget/list_song_carousel.dart';
import 'package:flutter_music_app/ui/widget/search_artist_carousel.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_music_app/service/base_repository.dart';

class HistorySearchPage extends StatefulWidget {
  @override
  _HistorySearchPageState createState() => _HistorySearchPageState();
}

class _HistorySearchPageState extends State<HistorySearchPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController controllerRecord;
  Animation<double> animationRecord;
  final _inputController = TextEditingController();
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  bool isSearch = false;
  List<Song> playlists = [];
  List<Song> listSongs = [];
  List<int> counter = [];
  List<Artist> artists = [];
  TabController tabController;
  String q;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
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
    _inputController.dispose();
    controllerRecord.dispose();
    super.dispose();
  }

  changeTabBarView(int index) {
    tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SongModel songModel = Provider.of(context);
    if (songModel.isPlaying) {
      controllerRecord.forward();
    } else {
      controllerRecord.stop(canceled: false);
    }
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: ProviderWidget<HomeModel>(
              onModelReady: (homeModel) async {
                //await homeModel.initData();
              },
              model: HomeModel(),
              autoDispose: false,
              builder: (context, homeModel, child) {
                if (homeModel.busy) {
                  return ViewStateBusyWidget();
                } else if (homeModel.error && homeModel.list.isEmpty) {
                  return ViewStateErrorWidget(
                      error: homeModel.viewStateError,
                      onPressed: homeModel.initData);
                }
                return Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).accentColor.withAlpha(50),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey,
                                ),
                                controller: _inputController,
                                onChanged: (value) {
                                  setState(() {
                                    isSearch = false;
                                  });
                                },
                                onSubmitted: (value) async {
                                  if (value.isNotEmpty == true) {
                                    setState(() {
                                      q = value;
                                      listSongs = [];
                                      playlists = [];
                                      artists = [];
                                    });
                                    var one =
                                        await BaseRepository.fetchSearchAll(
                                            value, "songs");
                                    var two =
                                        await BaseRepository.fetchSearchAll(
                                            value, "playlists");
                                    var three =
                                        await BaseRepository.fetchSearchAll(
                                            value, "counter");
                                    var four =
                                        await BaseRepository.fetchSearchAll(
                                            value, "artists");
                                    setState(() {
                                      listSongs = one;
                                      playlists = two;
                                      artists = four;
                                      counter = three;
                                      var flag = false;
                                      counter.forEach((element) {
                                        if (element != 0) {
                                          flag = true;
                                        }
                                        if (flag)
                                          isSearch = true;
                                        else
                                          isSearch = false;
                                      });
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    hintText: songModel.songs != null
                                        ? songModel.currentSong.title
                                        : S.of(context).searchSuggest),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: RotateRecord(
                              animation:
                                  _commonTween.animate(controllerRecord)),
                        ),
                      ],
                    ),
                  ),
                  isSearch == true
                      ? Expanded(
                          child: DefaultTabController(
                              length: tabController.length,
                              child: Scaffold(
                                appBar: AppBar(
                                  //textTheme: Theme.of(context).appBarTheme.color,
                                  backgroundColor: Colors.white,
                                  //shadowColor: Theme.of(context).accentColor,
                                  toolbarHeight: 50,
                                  automaticallyImplyLeading: false,
                                  bottom: TabBar(
                                    controller: tabController,
                                    isScrollable: true,
                                    tabs: [
                                      Tab(text: "Tất cả"),
                                      Tab(text: "Bài hát"),
                                      Tab(text: "Playlist"),
                                      Tab(text: "MV"),
                                      Tab(text: "Nghệ sĩ"),
                                    ],
                                    labelColor: Theme.of(context).accentColor,
                                    indicatorColor:
                                        Theme.of(context).accentColor,
                                  ),
                                ),
                                body: TabBarView(
                                  controller: tabController,
                                  children: <Widget>[
                                    Expanded(
                                      child: SmartRefresher(
                                        controller: homeModel.refreshController,
                                        onRefresh: () async {
                                          await homeModel.refresh();
                                          homeModel.showErrorMessage(context);
                                        },
                                        child: ListView(children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ForYouCarousel(listSongs, "song new",
                                              true, true, changeTabBarView),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          AlbumsCarousel(playlists, true, false,
                                              false, changeTabBarView),
                                          ListArtistsCarousel(
                                              artists, true, changeTabBarView),
                                        ]),
                                      ),
                                    ),
                                    Expanded(
                                        child: ListSongCarousel(
                                      input: q,
                                      type: "song",
                                      isAlbum: false,
                                    )),
                                    Expanded(
                                        child: ListSongCarousel(
                                            input: q,
                                            type: "playlist",
                                            isAlbum: true)),
                                    Text("4"),
                                    Expanded(
                                        child: SearchArtistCarousel(input: q)),
                                  ],
                                ),
                              )))
                      : Expanded(
                          child: Center(child: Text("Đang tải...")),
                        )
                ]);
              }),
        ),
      ),
    );
  }
}
