import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/provider/view_state_refresh_list_model.dart';
import 'package:flutter_music_app/service/base_repository.dart';

class SongListModel extends ViewStateRefreshListModel<Song> {
  List<Song> _song;
  List<Song> _sections;
  List<Artist> _artists;

  final String input;
  final bool isAlbum;

  SongListModel({this.input, this.isAlbum});

  List<Song> get song => _song;

  List<Song> get sections => _sections;

  List<Artist> get artists => _artists;

  @override
  Future<List<Song>> loadData({int pageNum}) async {
    //debugPrint("IS ALBUM " + isAlbum.toString());
    List<Future> futures = [];
    futures.add(BaseRepository.fetchAlbums(input, 'song', pageNum));
    futures.add(BaseRepository.fetchAlbums(input, 'sections', pageNum));
    if (!isAlbum) futures.add(BaseRepository.fetchParticipants(input));

    var result = await Future.wait(futures);
    _song = result[0];
    _sections = result[1];
    _artists = isAlbum == false ? result[2] : [];
    return result[1];
  }
}

class PlaylistModel extends ViewStateRefreshListModel<Song> {
  List<Song> _sections;
  final String input;

  PlaylistModel({this.input});

  List<Song> get sections => _sections;

  @override
  Future<List<Song>> loadData({int pageNum}) async {
    List<Future> futures = [];
    futures.add(BaseRepository.fetchPlaylists(input));

    var result = await Future.wait(futures);
    _sections = result[0];
    return result[0];
  }
}

class ChartModel extends ViewStateRefreshListModel<Song> {
  List<Song> _chartVN;
  List<Song> _chartUSUK;
  List<Song> _chartKPOP;

  String week;
  String year;

  ChartModel({this.week, this.year});

  List<Song> get chartVN => _chartVN;
  List<Song> get chartUSUK => _chartUSUK;
  List<Song> get chartKPOP => _chartKPOP;

  @override
  Future<List<Song>> loadData({int pageNum}) async {
    List<Future> futures = [];
    futures.add(BaseRepository.fetchChart(week, year, "IWZ9Z08I"));
    futures.add(BaseRepository.fetchChart(week, year, "IWZ9Z0BW"));
    futures.add(BaseRepository.fetchChart(week, year, "IWZ9Z0BO"));

    var result = await Future.wait(futures);
    _chartVN = result[0];
    _chartUSUK = result[1];
    _chartKPOP = result[2];
    return result[0];
  }
}

class Top100Model extends ViewStateRefreshListModel<Song> {
  List<Song> _top;
  List<Song> _listVN;
  List<Song> _listAuMy;
  List<Song> _listChauA;
  List<Song> _listHoaTau;

  List<Song> get top => _top;
  List<Song> get listVN => _listVN;
  List<Song> get listAuMy => _listAuMy;
  List<Song> get listChauA => _listChauA;
  List<Song> get listHoaTau => _listHoaTau;

  @override
  Future<List<Song>> loadData({int pageNum}) async {
    List<Future> futures = [];
    futures.add(BaseRepository.fetchTop100("top"));
    futures.add(BaseRepository.fetchTop100("VietNam"));
    futures.add(BaseRepository.fetchTop100("AuMy"));
    futures.add(BaseRepository.fetchTop100("ChauA"));
    futures.add(BaseRepository.fetchTop100("HoaTau"));

    var result = await Future.wait(futures);
    _top = result[0];
    _listVN = result[1];
    _listAuMy = result[2];
    _listChauA = result[3];
    _listHoaTau = result[4];

    return result[0];
  }
}

class ListSongModel extends ViewStateRefreshListModel<Song> {
  List<Song> _songs;
  final String input;
  final String type;

  ListSongModel({this.input, this.type});

  List<Song> get songs => _songs;

  @override
  Future<List<Song>> loadData({int pageNum}) async {
    List<Future> futures = [];
    futures.add(BaseRepository.fetchSearchType(input, type, pageNum));

    var result = await Future.wait(futures);
    _songs = result[0];
    return result[0];
  }
}

class NewSongModel extends ViewStateRefreshListModel<Song> {
  List<Song> _songs;
  int type;
  String parentId;

  List<Song> get songs => _songs;

  NewSongModel({this.type, this.parentId});

  @override
  Future<List<Song>> loadData({int pageNum}) async {
    List<Future> futures = [];
    debugPrint("TYPE = " + this.type.toString() + "PAR = " + this.parentId);
    if (this.type == 1)
      futures.add(BaseRepository.fetchNewReleaseChart());
    else if (this.type == 2)
      futures.add(BaseRepository.fetchListSong(this.parentId, "artist", 1));

    var result = await Future.wait(futures);
    _songs = result[0];
    return result[0];
  }
}

class SongModel with ChangeNotifier {
  String _lyric;
  String _url;
  Duration _timer = Duration(minutes: -1);
  List<Comment> _comments;

  Duration get timer => _timer;

  String get url => _url;

  String get lyric => _lyric;

  List<Comment> get comments => _comments;

  setUrl(String url) {
    //debugPrint("duration + " + data.duration.toString());
    _url = url;
    setComments();
    //debugPrint("link + " + _url);
    notifyListeners();
  }

  setTimer(Duration timer) {
    //debugPrint("duration + " + data.duration.toString());
    _timer = timer;
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

  pause() {
    audioPlayer.pause();
    notifyListeners();
  }

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

  setRepeat(bool isRepeat) {
    _isRepeat = isRepeat;
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

  setComments() async {
    _comments = await BaseRepository.fetchCommentSong(currentSong.id);
    debugPrint("NÂNNA" + _comments.toString());
    notifyListeners();
  }

  addComments(String username, String content) async {
    await BaseRepository.addCommentSong(currentSong.id,
        FirebaseAuth.instance.currentUser.uid + ".." + username, content);
    setComments();
    notifyListeners();
  }
}

class SongCollection {
  static cast(List<dynamic> data) {
    List<Song> songs = [];

    data.forEach((element) {
      if (element is Song) {
        songs.add(element);
      } else {
        songs.add(Song.fromJsonMap(element));
      }
    });

    return songs;
  }
}

class Comment {
  int id;
  String user_id;
  String content;
  String music_id;
  String user_name;

  Comment({this.id, this.user_id, this.content, this.music_id, this.user_name});

  factory Comment.fromJsonMap(Map<String, dynamic> map) {
    return Comment(
        content: map["content"],
        id: map["id"],
        user_id: (map["user_id"].split("..")).first,
        user_name: (map["user_id"].split("..")).last,
        music_id: map["music_id"]);
  }
}

class Song with ChangeNotifier {
  String id;
  String title;
  String artistName;
  int rawID;
  String link;
  String thumbnail;
  String thumbnailM;
  String lyric;
  int listen;
  int duration;
  bool isAlbum;
  bool hasLyric;
  List<Artist> artists;

  /*List<Artist> get artists => _artists;
  setArtists(List<Artist> artists) {
    _artists = artists;
    notifyListeners();
  }*/

  Song(
      {this.id,
      this.title,
      this.artistName,
      this.rawID,
      this.link,
      this.thumbnail,
      this.lyric,
      this.listen,
      this.duration,
      this.isAlbum,
      this.hasLyric,
      this.artists,
      this.thumbnailM});

  factory Song.fromJsonMap(Map<String, dynamic> map) {
    List<Artist> re = [];
    if (map["artists"] != null) {
      map["artists"].forEach((item) => re.add(Artist.fromJsonMap(item)));
    }
    return Song(
      id: map["id"] != null ? map["id"] : map["encodeId"],
      title: map["title"],
      artistName: map["artists_names"] != null
          ? map["artists_names"]
          : (map["artistsNames"] != null ? map["artistsNames"] : " "),
      rawID: map["raw_id"] != null ? map["raw_id"] : 0,
      link: map["link"] != null ? map["link"] : null,
      //link ="https://vnso-zn-15-tf-mp3-s1-zmp3.zadn.vn/a8130c96bbd1528f0bc0/3825616758110698709?authen=exp=1608794559~acl=/a8130c96bbd1528f0bc0/*~hmac=a484701b568e454e50abb3edde11531c&fs=MTYwODYyMTmUsIC1OTU5Mnx3ZWJWNnwxMDQ2MzUyMzM2fDE3MS4yNDmUsICdUngMTmUsICwLjExNw",
      thumbnail: map["thumbnail"] != null ? map["thumbnail"] : null,
      thumbnailM: map["thumbnail_medium"] != null
          ? map["thumbnail_medium"]
          : (map["thumbnailM"] != null ? map["thumbnailM"] : null),
      lyric: map["lyric"] != null ? map["lyric"] : null,
      listen: map["listen"] != null ? map["listen"] : null,
      duration: map["duration"] != null ? map["duration"] : null,
      isAlbum: map["isalbum"] != null
          ? map["isalbum"]
          : (map["isAlbum"] != null ? map["isAlbum"] : false),
      hasLyric: map["has_lyric"] != null
          ? map["has_lyric"]
          : (map["hasLyric"] != null ? map["hasLyric"] : false),
      artists: re,
    );
  }

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
    data['hasLyric'] = hasLyric;
    return data;
  }
}
