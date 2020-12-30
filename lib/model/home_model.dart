import 'dart:math';

import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/view_state_refresh_list_model.dart';
import 'package:flutter_music_app/service/base_repository.dart';

class HomeModel extends ViewStateRefreshListModel {
  List<Song> _albums;
  List<Song> _forYou;
  List<Song> _top100;
  List<Song> _nations;
  List<Song> _genre;
  List<Song> _topic;
  List<Artist> _spotlight;

  List<Song> get albums => _albums;

  List<Song> get forYou => _forYou;

  List<Song> get top100 => _top100;

  List<Song> get nations => _nations;

  List<Song> get genre => _genre;

  List<Song> get topic => _topic;

  List<Artist> get spotlight => _spotlight;

  @override
  Future<List<Song>> loadData({int pageNum}) async {
    List<Future> futures = [];
    futures.add(BaseRepository.fetchHomeList('album_hot', pageNum));
    futures.add(BaseRepository.fetchHomeList('song_new', pageNum));
    futures.add(BaseRepository.fetchHomeList('top100', pageNum));
    futures.add(BaseRepository.fetchHomeList('spotlight', pageNum));
    futures.add(BaseRepository.fetchHubHome('genre', pageNum));
    futures.add(BaseRepository.fetchHubHome('topic', pageNum));
    futures.add(BaseRepository.fetchHubHome('nations', pageNum));

    var result = await Future.wait(futures);
    _albums = result[0];
    _forYou = result[1];
    _top100 = result[2];
    _spotlight = result[3];
    _genre = result[4];
    _topic = result[5];
    _nations = result[6];
    return result[1];
  }
}
