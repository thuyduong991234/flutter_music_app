import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/view_state_list_model.dart';
import 'package:flutter_music_app/provider/view_state_refresh_list_model.dart';
import 'package:localstorage/localstorage.dart';

const String kLocalStorageSearch = 'kLocalStorageSearch';
const String kFavoriteList = 'kFavoriteList';
const String kPlaylist = 'kPlaylist';

/// 我的收藏列表
class FavoriteListModel extends ViewStateListModel<Song> {
  FavoriteModel favoriteModel;

  FavoriteListModel({this.favoriteModel});

  @override
  Future<List<Song>> loadData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    List<Song> favoriteList =
        (localStorage.getItem(kFavoriteList) ?? []).map<Song>((item) {
      debugPrint("ITEM LOAD FAVOR = " + item.toString());
      return Song.fromJsonMap(item);
    }).toList();
    Map<String, List<dynamic>> playlist;
    if (localStorage.getItem(kPlaylist) != null) {
      playlist = Map.from(localStorage.getItem(kPlaylist));
    } else {
      playlist = Map<String, List<dynamic>>();
    }
    favoriteModel.setFavorites(favoriteList);
    favoriteModel.setPlaylists(playlist);
    setIdle();
    return favoriteList;
  }
}

class PlaylistSongModel extends ViewStateRefreshListModel<dynamic> {
  String name;

  List<dynamic> _songs;

  List<dynamic> get songs => _songs;

  PlaylistSongModel({this.name});

  @override
  Future<List<dynamic>> loadData({int pageNum}) async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;

    Map<String, List<dynamic>> playlist;
    if (localStorage.getItem(kPlaylist) != null) {
      playlist = Map.from(localStorage.getItem(kPlaylist));
    } else {
      playlist = Map<String, List<dynamic>>();
    }
    var map = playlist[name];

    _songs = List.from(map);
    return _songs;
  }
}

class FavoriteModel with ChangeNotifier {
  List<Song> _favoriteSong;
  Map<String, List<dynamic>> _playlists;

  List<Song> get favoriteSong => _favoriteSong;

  Map<String, List<dynamic>> get playlists => _playlists;

  setFavorites(List<Song> favoriteSong) {
    _favoriteSong = favoriteSong;
    notifyListeners();
  }

  setPlaylists(Map<String, List<dynamic>> playlist) {
    _playlists = playlist;
    notifyListeners();
  }

  collect(Song song) {
    debugPrint("COLLECT THU VIEN + " + song.hasLyric.toString());
    if (_favoriteSong.contains(song)) {
      _favoriteSong.remove(song);
    } else {
      _favoriteSong.add(song);
    }
    saveData();
    notifyListeners();
  }

  collect2(String name, Song song) {
    if (!_playlists.containsKey(name)) {
      _playlists[name] = [];
    }
    Song deletion = isCollect2(song, _playlists[name]);

    if (deletion != null) {
      _playlists[name] = remove2(deletion, _playlists[name]);
    } else {
      _playlists[name].add(song);
    }

    saveData();
    notifyListeners();
  }

  saveData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    localStorage.setItem(kFavoriteList, _favoriteSong);
    localStorage.setItem(kPlaylist, _playlists);

    for (int i = 0; i < _favoriteSong.length; i++) {
      debugPrint("EVERY FAVOURITE SONG = " +
          i.toString() +
          " = " +
          _favoriteSong[i].hasLyric.toString());
    }
  }

  isCollect(Song newSong) {
    bool isCollect = false;
    for (int i = 0; i < _favoriteSong.length; i++) {
      if (_favoriteSong[i].id == newSong.id) {
        isCollect = true;
        break;
      }
    }
    return isCollect;
  }

  Song isCollect2(Song newSong, List<dynamic> data) {
    Song result;

    for (int i = 0; i < data.length; i++) {
      var compare = data[i] is Song ? data[i].id : data[i]["id"];
      if (compare == newSong.id) {
        result = newSong;
      }
    }

    return result;
  }

  remove2(Song newSong, List<dynamic> data) {
    for (int i = 0; i < data.length; i++) {
      var compare = data[i] is Song ? data[i].id : data[i]["id"];
      if (compare == newSong.id) {
        data.removeAt(i);
      }
    }

    return data;
  }

  removePlaylist(String name) {
    _playlists.removeWhere((key, value) => key == name);

    saveData();
    notifyListeners();
  }

  refresh() {
    _playlists = new Map();
    _favoriteSong = [];

    saveData();
    notifyListeners();
  }
}
