import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/page/albums_page.dart';
import 'package:flutter_music_app/ui/widget/app_bar.dart';

class PlaylistsCarousel extends StatefulWidget {
  final String id;
  final String title;

  PlaylistsCarousel({this.id, this.title});
  @override
  _PlaylistsCarouselState createState() => _PlaylistsCarouselState();
}

class _PlaylistsCarouselState extends State<PlaylistsCarousel> {
  //List<Song> playlist;
  @override
  void initState() {
    super.initState();
    //fetchPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ProviderWidget<PlaylistModel>(
                onModelReady: (model) async {
                  await model.initData();
                },
                model: PlaylistModel(input: widget.id),
                builder: (context, model, child) {
                  if (model.busy) {
                    return ViewStateBusyWidget();
                  } else if (model.error && model.list.isEmpty) {
                    return ViewStateErrorWidget(
                        error: model.viewStateError, onPressed: model.initData);
                  }
                  var playlists = model?.sections ?? [];
                  return Column(
                    children: <Widget>[
                      AppBarCarousel(
                        title: widget.title,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: playlists.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20.0,
                                  mainAxisSpacing: 5.0),
                          itemBuilder: (BuildContext context, int index) {
                            Song data = playlists[index];
                            data.isAlbum = false;
                            return GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AlbumsPage(
                                      data: data,
                                      isAlbum: true,
                                    ),
                                  ),
                                ),
                              },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image(
                                          height: 140.0,
                                          width: 160.0,
                                          image: CachedNetworkImageProvider(
                                              data.thumbnail),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        data.title,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                  );
                })));
  }
}
