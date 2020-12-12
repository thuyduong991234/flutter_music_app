import 'dart:math';

import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/view_state_refresh_list_model.dart';
import 'package:flutter_music_app/service/base_repository.dart';

class HomeModel extends ViewStateRefreshListModel {
  List<Song> _albums;
  List<Song> _forYou;
  List<Song> get albums => _albums;

  List<Song> get forYou => _forYou;
  @override
  Future<List<Song>> loadData({int pageNum}) async {
    List<Future> futures = [];
    futures.add(BaseRepository.fetchHomeList('album_hot', pageNum));
    futures.add(BaseRepository.fetchHomeList('song_new', pageNum));

    var result = await Future.wait(futures);
    _albums = result[0];
    _forYou = result[1];
    return result[1];
  }
}
