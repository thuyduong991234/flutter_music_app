import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/page/player_page.dart';
import 'package:flutter_music_app/ui/widget/add_to_playlist.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var top = 0.0;
  int week = 52;
  int year = 2020;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildSongItem(Song data, int index) {
    FavoriteModel favoriteModel = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            child: Container(
                width: 30,
                height: 50,
                child: Center(
                    child: Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: index == 1
                        ? Colors.blue
                        : (index == 2
                            ? Colors.green
                            : (index == 3 ? Colors.orange : Colors.grey)),
                  ),
                ))),
          ),
          SizedBox(
            width: 20.0,
          ),
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
          AddPlayList(data, favoriteModel)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
                child: ProviderWidget<ChartModel>(
                    onModelReady: (model) async {
                      await model.initData();
                    },
                    model: ChartModel(
                        week: week.toString(), year: year.toString()),
                    builder: (context, model, child) {
                      if (model.busy) {
                        return ViewStateBusyWidget();
                      } else if (model.error && model.list.isEmpty) {
                        return ViewStateErrorWidget(
                            error: model.viewStateError,
                            onPressed: model.initData);
                      }
                      var chartVN = model?.chartVN ?? [];
                      var chartUSUK = model?.chartUSUK ?? [];
                      var chartKPOP = model?.chartKPOP ?? [];
                      int _week = week;
                      int _year = year;
                      //debugPrint("WEEEK" + week.toString());
                      return StatefulBuilder(builder: (context, setState) {
                        return DefaultTabController(
                            length: 3,
                            child: Scaffold(
                                body: NestedScrollView(
                              floatHeaderSlivers: true,
                              headerSliverBuilder: (BuildContext context,
                                  bool innerBoxIsScrolled) {
                                return <Widget>[
                                  SliverAppBar(
                                    collapsedHeight: 60,
                                    pinned: true,
                                    title: Text(
                                      "#CHART TUẦN",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    floating: true,
                                    flexibleSpace: LayoutBuilder(builder:
                                        (BuildContext context,
                                            BoxConstraints constraints) {
                                      top = constraints.biggest.height;
                                      if (top == 200) {
                                        return FlexibleSpaceBar(
                                            centerTitle: true,
                                            title: AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                opacity:
                                                    top == 200.0 ? 1.0 : 0.0,
                                                //opacity: 1.0,
                                                child: Center(
                                                    child: GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                          return AlertDialog(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 50.0,
                                                              ),
                                                              content: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    height: 150,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        IconButton(
                                                                            icon:
                                                                                Icon(
                                                                              Icons.add,
                                                                              color: Theme.of(context).accentColor,
                                                                              size: 30.0,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                week = week + 1;
                                                                              });
                                                                            }),
                                                                        Text(
                                                                            week
                                                                                .toString(),
                                                                            style:
                                                                                TextStyle(fontSize: 18)),
                                                                        IconButton(
                                                                            icon:
                                                                                Icon(
                                                                              Icons.remove,
                                                                              color: Theme.of(context).accentColor,
                                                                              size: 30.0,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                week--;
                                                                              });
                                                                            }),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 150,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        IconButton(
                                                                            icon:
                                                                                Icon(
                                                                              Icons.add,
                                                                              color: Theme.of(context).accentColor,
                                                                              size: 30.0,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                year++;
                                                                              });
                                                                            }),
                                                                        Text(
                                                                            year
                                                                                .toString(),
                                                                            style:
                                                                                TextStyle(fontSize: 18)),
                                                                        IconButton(
                                                                            icon:
                                                                                Icon(
                                                                              Icons.remove,
                                                                              color: Theme.of(context).accentColor,
                                                                              size: 30.0,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                year--;
                                                                              });
                                                                            }),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        week =
                                                                            _week;
                                                                        year =
                                                                            _year;
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        S
                                                                            .of(
                                                                                context)
                                                                            .actionCancel,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).accentColor))),
                                                                MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      model.week =
                                                                          week.toString();
                                                                      model.year =
                                                                          year.toString();
                                                                      model
                                                                          .refresh();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        S
                                                                            .of(
                                                                                context)
                                                                            .actionConfirm,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).accentColor)))
                                                              ]);
                                                        });
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 35,
                                                    margin: EdgeInsets.only(
                                                        top: 80,
                                                        bottom: 20,
                                                        left: 70,
                                                        right: 70),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          "Tuần " +
                                                              model.week
                                                                  .toString() +
                                                              " - " +
                                                              model.year
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))),
                                            background: Image(
                                                height: 200.0,
                                                width: 160.0,
                                                image:
                                                    CachedNetworkImageProvider(
                                                        chartVN[0].thumbnailM),
                                                fit: BoxFit.cover,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.5),
                                                colorBlendMode:
                                                    BlendMode.modulate));
                                      }
                                      return Image(
                                          height: 200.0,
                                          width: 160.0,
                                          image: CachedNetworkImageProvider(
                                              chartVN[0].thumbnailM),
                                          fit: BoxFit.cover,
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.5),
                                          colorBlendMode: BlendMode.modulate);
                                    }),
                                    expandedHeight: 200,
                                    bottom: TabBar(
                                      isScrollable: false,
                                      tabs: [
                                        Tab(text: "VIỆT NAM"),
                                        Tab(text: "US-UK"),
                                        Tab(text: "K-POP"),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              body: TabBarView(children: <Widget>[
                                ListView.builder(
                                    shrinkWrap: true, //解决无限高度问题
                                    scrollDirection: Axis.vertical,
                                    itemCount: chartVN.length + 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0) {
                                        return Center(
                                          child: Container(
                                            height: 50,
                                            margin: EdgeInsets.only(
                                                top: 20,
                                                bottom: 20,
                                                left: 90,
                                                right: 90),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Colors.black12
                                                      : Colors.grey[500],
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(40.0),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (null != chartVN[0].link) {
                                                  SongModel songModel =
                                                      Provider.of(context);
                                                  songModel.setSongs(chartVN);
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.play_arrow,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Phát ngẫu nhiên",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      index--;
                                      Song data = chartVN[index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (null != data.link) {
                                            SongModel songModel =
                                                Provider.of(context);
                                            songModel.setSongs(model.chartVN);
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
                                    }),
                                ListView.builder(
                                    shrinkWrap: true, //解决无限高度问题
                                    scrollDirection: Axis.vertical,
                                    itemCount: chartUSUK.length + 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0) {
                                        return Center(
                                          child: Container(
                                            height: 50,
                                            margin: EdgeInsets.only(
                                                top: 20,
                                                bottom: 20,
                                                left: 90,
                                                right: 90),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Colors.black12
                                                      : Colors.grey[500],
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(40.0),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (null != chartUSUK[0].link) {
                                                  SongModel songModel =
                                                      Provider.of(context);
                                                  songModel.setSongs(chartUSUK);
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.play_arrow,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Phát ngẫu nhiên",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      index--;
                                      Song data = chartUSUK[index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (null != data.link) {
                                            SongModel songModel =
                                                Provider.of(context);
                                            songModel.setSongs(model.chartUSUK);
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
                                    }),
                                ListView.builder(
                                    shrinkWrap: true, //解决无限高度问题
                                    scrollDirection: Axis.vertical,
                                    itemCount: chartKPOP.length + 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0) {
                                        return Center(
                                          child: Container(
                                            height: 50,
                                            margin: EdgeInsets.only(
                                                top: 20,
                                                bottom: 20,
                                                left: 90,
                                                right: 90),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Colors.black12
                                                      : Colors.grey[500],
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(40.0),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (null != chartKPOP[0].link) {
                                                  SongModel songModel =
                                                      Provider.of(context);
                                                  songModel.setSongs(chartKPOP);
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.play_arrow,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Phát ngẫu nhiên",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      index--;
                                      Song data = chartKPOP[index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (null != data.link) {
                                            SongModel songModel =
                                                Provider.of(context);
                                            songModel.setSongs(model.chartKPOP);
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
                                    }),
                              ]),
                            )));
                      });
                    }))));
  }
}
