import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/provider/view_state_refresh_list_model.dart';
import 'package:flutter_music_app/service/base_repository.dart';

class SongListModel extends ViewStateRefreshListModel<Song> {
  List<Song> _song;
  List<Song> _sections;
  final String input;

  SongListModel({this.input});

  List<Song> get song => _song;

  List<Song> get sections => _sections;
  @override
  Future<List<Song>> loadData({int pageNum}) async {
    List<Future> futures = [];
    futures.add(BaseRepository.fetchAlbums(input, 'song', pageNum));
    futures.add(BaseRepository.fetchAlbums(input, 'sections', pageNum));

    var result = await Future.wait(futures);
    _song = result[0];
    _sections = result[1];
    return result[1];
  }
}

class SongModel with ChangeNotifier {
  String _lyric;
  String _url;
  String get url => _url;
  String get lyric => _lyric;
  setUrl(String url) {
    //debugPrint("duration + " + data.duration.toString());
    _url = url;
    //debugPrint("link + " + _url);
    notifyListeners();
  }

  setLyric(String lyric) {
    //debugPrint("duration + " + data.duration.toString());
    _lyric = lyric;
    //debugPrint("link + " + _url);
    notifyListeners();
  }

  AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer get audioPlayer => _audioPlayer;

  List<Song> _songs;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  setPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  bool _isRepeat = true;
  bool get isRepeat => _isRepeat;
  changeRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  bool _showList = false;
  bool get showList => _showList;
  setShowList(bool showList) {
    _showList = showList;
    notifyListeners();
  }

  int _currentSongIndex = 0;

  List<Song> get songs => _songs;
  setSongs(List<Song> songs) {
    _songs = songs;
    notifyListeners();
  }

  addSongs(List<Song> songs) {
    _songs.addAll(songs);
    notifyListeners();
  }

  int get length => _songs.length;
  int get songNumber => _currentSongIndex + 1;

  setCurrentIndex(int index) {
    _currentSongIndex = index;
    notifyListeners();
  }

  /// 在播放列表界面点击后立刻播放
  bool _playNow = false;
  bool get playNow => _playNow;
  setPlayNow(bool playNow) {
    _playNow = playNow;
    notifyListeners();
  }

  Song get currentSong => _songs[_currentSongIndex];

  Song get nextSong {
    if (isRepeat) {
      if (_currentSongIndex < length) {
        _currentSongIndex++;
      }
      if (_currentSongIndex == length) {
        _currentSongIndex = 0;
      }
    } else {
      Random r = new Random();
      _currentSongIndex = r.nextInt(_songs.length);
    }
    notifyListeners();
    return _songs[_currentSongIndex];
  }

  Song get prevSong {
    if (isRepeat) {
      if (_currentSongIndex > 0) {
        _currentSongIndex--;
      }
      if (_currentSongIndex == 0) {
        _currentSongIndex = length - 1;
      }
    } else {
      Random r = new Random();
      _currentSongIndex = r.nextInt(_songs.length);
    }
    notifyListeners();
    return _songs[_currentSongIndex];
  }

  Duration _position;
  Duration get position => _position;
  void setPosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  Duration _duration;
  Duration get duration => _duration;
  void setDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }
}

class Song {
  String id;
  String title;
  String artistName;
  String artistAlias;
  int rawID;
  String link;
  String thumbnail;
  String lyric;
  int listen;
  int duration;
  bool isAlbum;
  bool hasLyric;

  Song.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"] != null ? map["id"] : map["encodeId"],
        title = map["title"],
        artistName = map["artists_names"] != null
            ? map["artists_names"]
            : (map["artistsNames"] != null ? map["artistsNames"] : " "),
        rawID = map["raw_id"] != null ? map["raw_id"] : 0,
        link = map["link"],
        //link ="https://vnso-zn-15-tf-mp3-s1-zmp3.zadn.vn/a8130c96bbd1528f0bc0/3825616758110698709?authen=exp=1608794559~acl=/a8130c96bbd1528f0bc0/*~hmac=a484701b568e454e50abb3edde11531c&fs=MTYwODYyMTmUsIC1OTU5Mnx3ZWJWNnwxMDQ2MzUyMzM2fDE3MS4yNDmUsICdUngMTmUsICwLjExNw",
        thumbnail = map["thumbnail"],
        lyric = map["lyric"],
        listen = map["listen"],
        duration = map["duration"],
        isAlbum = map["isalbum"] != null
            ? map["isalbum"]
            : (map["isAlbum"] != null ? map["isAlbum"] : false),
        hasLyric = map["has_lyric"] != null
            ? map["has_lyric"]
            : (map["hasLyric"] != null ? map["hasLyric"] : false);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['artists_names'] = artistName;
    data['raw_id'] = rawID;
    //data['link'] ="https://vnso-zn-15-tf-mp3-s1-zmp3.zadn.vn/a8130c96bbd1528f0bc0/3825616758110698709?authen=exp=1608794559~acl=/a8130c96bbd1528f0bc0/*~hmac=a484701b568e454e50abb3edde11531c&fs=MTYwODYyMTmUsIC1OTU5Mnx3ZWJWNnwxMDQ2MzUyMzM2fDE3MS4yNDmUsICdUngMTmUsICwLjExNw";
    data['link'] = link;
    data['thumbnail'] = thumbnail;
    data['lyric'] = lyric;
    data['listen'] = listen;
    data['duration'] = duration;
    data['isalbum'] = isAlbum;
    return data;
  }
}
