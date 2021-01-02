import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/home_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/page/history_search_page.dart';
import 'package:flutter_music_app/ui/widget/albums_carousel.dart';
import 'package:flutter_music_app/anims/record_anim.dart';
import 'package:flutter_music_app/ui/widget/circle_artist_carousel.dart';
import 'package:flutter_music_app/ui/widget/for_you_carousel.dart';
import 'package:flutter_music_app/ui/page/search_page.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_music_app/service/base_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController controllerRecord;
  Animation<double> animationRecord;
  final _inputController = TextEditingController();
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    BaseRepository.fetchHomeList(null, null);
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
                await homeModel.initData();
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
                var albums = homeModel?.albums ?? [];
                var forYou = homeModel?.forYou ?? [];
                var top100 = homeModel?.top100 ?? [];
                var genre = homeModel?.genre ?? [];
                var topic = homeModel?.topic ?? [];
                var nations = homeModel?.nations ?? [];
                var spotlight = homeModel?.spotlight ?? [];
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
                              animation:
                                  _commonTween.animate(controllerRecord)),
                        ),
                      ],
                    ),
                  ),
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
                        AlbumsCarousel(albums, false, false, false, null),
                        ForYouCarousel(forYou, "song new", true, false, null),
                        SizedBox(
                          height: 20,
                        ),
                        AlbumsCarousel(top100, false, false, true, null),
                        AlbumsCarousel(genre, false, true, false, null),
                        AlbumsCarousel(topic, false, true, false, null),
                        AlbumsCarousel(nations, false, true, false, null),
                        CircleArtistsCarousel(spotlight),
                      ]),
                    ),
                  )
                ]);
              }),
        ),
      ),
    );
  }
}
