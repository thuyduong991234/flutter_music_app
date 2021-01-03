import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_music_app/config/net/base_api.dart';
import 'package:flutter_music_app/model/artist_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:http/http.dart' as htp;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class BaseRepository {
  /// 获取音乐列表
  static String api_key = "38e8643fb0dc04e8d65b99994d3dafff";
  static String secret_key = "10a01dcf33762d3a204cb96429918ff6";

  static Future fetchSongList(String input, int page) async {
    var response = [];
    return response.map<Song>((item) => Song.fromJsonMap(item)).toList();
  }

  static Future fetchHomeList(String input, int page) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString();
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/home" + _sha256.toString();
    var hmac = new Hmac(sha512, utf8.encode(secret_key));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/home?ctime=' +
        ctime.toString() +
        "&sig=" +
        sig.toString() +
        "&api_key=" +
        api_key);
    //debugPrint(response.toString());
    if ((response.toString()).contains("-204")) {
      response = await http.get('/home?ctime=' +
          ctime.toString() +
          "&sig=" +
          sig.toString() +
          "&api_key=" +
          api_key);
    }

    //});

    switch (input) {
      case 'song_new':
        List<Song> recommendSong = [];
        response.data['song_new']['items']
            .forEach((item) => recommendSong.add(Song.fromJsonMap(item)));
        return recommendSong;
        break;
      case 'album_hot':
        List<Song> listAlbum = [];
        response.data['album_hot']['items']
            .forEach((item) => listAlbum.add(Song.fromJsonMap(item)));
        return listAlbum;
        break;
      case 'top100':
        List<Song> top100 = [];
        response.data['top100']['items']
            .forEach((item) => top100.add(Song.fromJsonMap(item)));
        return top100;
        break;
      case 'spotlight':
        List<Artist> spotlight = [];
        response.data['spotlight']
            .forEach((item) => spotlight.add(Artist.fromJsonMap(item)));
        return spotlight;
        break;
      default:
    }
  }

  static Future fetchHubHome(String input, int page) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString() + "version=1.0.10";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/hub/getHome" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/v2/hub/getHome?ctime=' +
        ctime.toString() +
        "&version=1.0.10" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    //debugPrint(response.toString());
    if ((response.toString()).contains("-204")) {
      response = await http.get('/v2/hub/getHome?ctime=' +
          ctime.toString() +
          "&version=1.0.10" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }

    //});

    switch (input) {
      case 'topic':
        List<Song> topic = [];
        response.data['topic']
            .forEach((item) => topic.add(Song.fromJsonMap(item)));
        return topic;
        break;
      case 'nations':
        List<Song> nations = [];
        response.data['nations']
            .forEach((item) => nations.add(Song.fromJsonMap(item)));
        return nations;
        break;
      case 'genre':
        List<Song> genre = [];
        response.data['genre']
            .forEach((item) => genre.add(Song.fromJsonMap(item)));
        return genre;
        break;
      default:
    }
  }

  static Future fetchUrlMp3(String input) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString() + "id=" + input + "version=1.0.1";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/song/getStreaming" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/v2/song/getStreaming?id=' +
        input +
        "&ctime=" +
        ctime.toString() +
        "&version=1.0.1" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      debugPrint("Có vô IF");
      response = await http.get('/v2/song/getStreaming?id=' +
          input +
          "&ctime=" +
          ctime.toString() +
          "&version=1.0.1" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }
    debugPrint("response url: " + response.data["128"].toString());
    return response.data["128"].toString();
  }

  static Future fetchLyrics(String input) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString() + "id=" + input + "version=1.0.1";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/lyric" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/v2/lyric?id=' +
        input +
        "&ctime=" +
        ctime.toString() +
        "&version=1.0.1" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      debugPrint("Có vô IF");
      response = await http.get('/v2/lyric?id=' +
          input +
          "&ctime=" +
          ctime.toString() +
          "&version=1.0.1" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }
    debugPrint("response file: " + response.data["file"].toString());
    return response.data["file"].toString();
  }

  static Future fetchAlbums(String id, String input, int page) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString() + "id=" + id + "version=1.0.1";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/playlist/getDetail" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/v2/playlist/getDetail?id=' +
        id +
        "&ctime=" +
        ctime.toString() +
        "&version=1.0.1" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      debugPrint("Có vô IF");
      response = await http.get('/v2/playlist/getDetail?id=' +
          id +
          "&ctime=" +
          ctime.toString() +
          "&version=1.0.1" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }
    switch (input) {
      case 'song':
        List<Song> songs = [];
        response.data['song']['items']
            .forEach((item) => songs.add(Song.fromJsonMap(item)));
        //debugPrint("LENGTH______" + songs.length.toString());
        return songs;
        break;
      case 'sections':
        List<Song> sections = [];
        //debugPrint("TRƯỚC SECTIONS ----------------" +
        //response.data['sections'][0]['items'].toString());
        if (response.data['sections'] != null) {
          response.data['sections'][0]['items']
              .forEach((item) => sections.add(Song.fromJsonMap(item)));
        }
        //debugPrint(
        //"SAU SECTIONS ----------------" + sections.length.toString());
        return sections;
        break;
      default:
    }
  }

  static Future fetchParticipants(String id) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString() + "id=" + id + "version=1.0.10";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/playlist/getSectionBottom" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/v2/playlist/getSectionBottom?id=' +
        id +
        "&ctime=" +
        ctime.toString() +
        "&version=1.0.10" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      debugPrint("Có vô IF");
      response = await http.get('/v2/playlist/getSectionBottom?id=' +
          id +
          "&ctime=" +
          ctime.toString() +
          "&version=1.0.10" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }
    List<Artist> participants = [];
    response.data[0]['items']
        .forEach((item) => participants.add(Artist.fromJsonMap(item)));
    //debugPrint("LENGTH______" + songs.length.toString());
    return participants;
  }

  static Future fetchPlaylists(String id) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString() + "id=" + id + "version=1.0.10";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/hub/getDetail" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/v2/hub/getDetail?id=' +
        id +
        "&ctime=" +
        ctime.toString() +
        "&version=1.0.10" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      debugPrint("Có vô IF");
      response = await http.get('/v2/hub/getDetail?id=' +
          id +
          "&ctime=" +
          ctime.toString() +
          "&version=1.0.10" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }

    List<Song> sections = [];
    if (response.data['sections'] != null) {
      response.data['sections'][0]['items']
          .forEach((item) => sections.add(Song.fromJsonMap(item)));
    }
    //debugPrint(
    //"SAU SECTIONS ----------------" + sections.length.toString());
    return sections;
  }

  static Future fetchTop100(String input) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString() + "version=1.0.13";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/top100" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/v2/top100?ctime=' +
        ctime.toString() +
        "&version=1.0.13" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      debugPrint("Có vô IF");
      response = await http.get('/v2/top100?ctime=' +
          ctime.toString() +
          "&version=1.0.13" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }

    List<Song> top100 = [];
    switch (input) {
      case 'top':
        response.data[0]['items']
            .forEach((item) => top100.add(Song.fromJsonMap(item)));
        //debugPrint("LENGTH______" + songs.length.toString());
        return top100;
        break;
      case 'VietNam':
        response.data[1]['items']
            .forEach((item) => top100.add(Song.fromJsonMap(item)));
        return top100;
        break;
      case 'AuMy':
        response.data[2]['items']
            .forEach((item) => top100.add(Song.fromJsonMap(item)));
        return top100;
        break;
      case 'ChauA':
        response.data[3]['items']
            .forEach((item) => top100.add(Song.fromJsonMap(item)));
        return top100;
        break;
      case 'HoaTau':
        response.data[4]['items']
            .forEach((item) => top100.add(Song.fromJsonMap(item)));
        return top100;
        break;
      default:
    }
  }

  static Future fetchChart(String week, String year, String id) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString() + "id=" + id + "version=1.0.13";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/chart/getWeekChart" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/v2/chart/getWeekChart?id=' +
        id +
        '&week=' +
        week +
        '&year=' +
        year +
        '&ctime=' +
        ctime.toString() +
        "&version=1.0.13" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      debugPrint("Có vô IF");
      response = await http.get('/v2/chart/getWeekChart?id=' +
          id +
          '&week=' +
          week +
          '&year=' +
          year +
          '&ctime=' +
          ctime.toString() +
          "&version=1.0.13" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }

    List<Song> songs = [];
    response.data['items'].forEach((item) => songs.add(Song.fromJsonMap(item)));
    return songs;
  }

  static Future fetchNewReleaseChart() async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString() + "version=1.0.13";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/chart/getNewReleaseChart" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/v2/chart/getNewReleaseChart?' +
        "&ctime=" +
        ctime.toString() +
        "&version=1.0.13" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      debugPrint("Có vô IF");
      response = await http.get('/v2/chart/getNewReleaseChart?' +
          "&ctime=" +
          ctime.toString() +
          "&version=1.0.13" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }

    List<Song> songs = [];
    response.data['items'].forEach((item) => songs.add(Song.fromJsonMap(item)));
    //debugPrint(
    //"SAU SECTIONS ----------------" + sections.length.toString());
    return songs;
  }

  static Future fetchSearchAll(String q, String input) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString() + "version=1.0.10";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/search/multi" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/v2/search/multi?q=' +
        q +
        "&ctime=" +
        ctime.toString() +
        "&version=1.0.10" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      debugPrint("Có vô IF");
      response = await http.get('/v2/search/multi?q=' +
          q +
          "&ctime=" +
          ctime.toString() +
          "&version=1.0.10" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }
    switch (input) {
      case 'songs':
        List<Song> songs = [];
        response.data['songs']
            .forEach((item) => songs.add(Song.fromJsonMap(item)));
        //debugPrint("LENGTH______" + songs.length.toString());
        return songs;
        break;
      case 'playlists':
        List<Song> sections = [];
        //debugPrint("TRƯỚC SECTIONS ----------------" +
        //response.data['sections'][0]['items'].toString());
        response.data['playlists']
            .forEach((item) => sections.add(Song.fromJsonMap(item)));
        debugPrint(
            "SAU SECTIONS ----------------" + sections.length.toString());
        return sections;
        break;
      case 'artists':
        List<Artist> artists = [];
        response.data['artists']
            .forEach((item) => artists.add(Artist.fromJsonMap(item)));
        return artists;
        break;
      case 'counter':
        List<int> counter = [];
        response.data['counter']['song'] != null
            ? counter.add(response.data['counter']['song'])
            : counter.add(0);
        response.data['counter']['artist'] != null
            ? counter.add(response.data['counter']['artist'])
            : counter.add(0);
        response.data['counter']['playlist'] != null
            ? counter.add(response.data['counter']['playlist'])
            : counter.add(0);
        response.data['counter']['video'] != null
            ? counter.add(response.data['counter']['video'])
            : counter.add(0);
        return counter;
      default:
    }
  }

  static Future fetchSearchType(String q, String type, int pageNum) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "count=18ctime=" +
        ctime.toString() +
        "page=" +
        pageNum.toString() +
        "type=" +
        type +
        "version=1.0.13";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/search" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    //Timer(Duration(seconds: 2), () async {
    response = await http.get('/v2/search?q=' +
        q +
        "&type=" +
        type +
        "&page=" +
        pageNum.toString() +
        "&count=18"
            "&ctime=" +
        ctime.toString() +
        "&version=1.0.13" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      debugPrint("Có vô IF");
      response = await http.get('/v2/search?q=' +
          q +
          "&type=" +
          type +
          "&page=" +
          pageNum.toString() +
          "&count=18"
              "&ctime=" +
          ctime.toString() +
          "&version=1.0.13" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }
    switch (type) {
      case 'song':
        List<Song> songs = [];
        response.data['items']
            .forEach((item) => songs.add(Song.fromJsonMap(item)));
        //debugPrint("LENGTH______" + songs.length.toString());
        return songs;
        break;
      case 'playlist':
        List<Song> sections = [];
        //debugPrint("TRƯỚC SECTIONS ----------------" +
        //response.data['sections'][0]['items'].toString());
        response.data['items']
            .forEach((item) => sections.add(Song.fromJsonMap(item)));
        return sections;
        break;
      case 'artist':
        List<Artist> artists = [];
        response.data['items']
            .forEach((item) => artists.add(Artist.fromJsonMap(item)));
        return artists;
        break;
      default:
    }
  }

  static Future fetchArtist(String alias) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "ctime=" + ctime.toString() + "version=1.0.1";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/artist/getDetail" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    response = await http.get('/v2/artist/getDetail?alias=' +
        alias +
        "&ctime=" +
        ctime.toString() +
        "&version=1.0.1" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      response = await http.get('/v2/artist/getDetail?alias=' +
          alias +
          "&ctime=" +
          ctime.toString() +
          "&version=1.0.1" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }
    return Artist.fromJsonMap(response.data);
  }

  static Future fetchListSong(String parentId, String type, int pageNum) async {
    var ctime = DateTime.now().millisecondsSinceEpoch;
    String data = "count=15ctime=" +
        ctime.toString() +
        "id=" +
        parentId +
        "page=" +
        pageNum.toString() +
        "type=" +
        type +
        "version=1.0.13";
    var _sha256 = sha256.convert(utf8.encode(data));
    var _sha512 = "/api/v2/song/getList" + _sha256.toString();
    var hmac =
        new Hmac(sha512, utf8.encode("882QcNXV4tUZbvAsjmFOHqNC1LpcBRKW"));
    var sig = hmac.convert(utf8.encode(_sha512));
    var response = null;
    response = await http.get('/v2/song/getList?id=' +
        parentId +
        "&type=" +
        type +
        "&page=" +
        pageNum.toString() +
        "&count=" +
        15.toString() +
        "&sort=new&sectionId=aSong" +
        "&ctime=" +
        ctime.toString() +
        "&version=1.0.13" +
        "&sig=" +
        sig.toString() +
        "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    if ((response.toString()).contains("-204")) {
      response = await http.get('/v2/song/getList?id=' +
          parentId +
          "&type=" +
          type +
          "&page=" +
          pageNum.toString() +
          "&count=" +
          15.toString() +
          "&sort=new&sectionId=aSong" +
          "&ctime=" +
          ctime.toString() +
          "&version=1.0.13" +
          "&sig=" +
          sig.toString() +
          "&apiKey=kI44ARvPwaqL7v0KuDSM0rGORtdY1nnw");
    }

    List<Song> songs = [];
    response.data['items'].forEach((item) => songs.add(Song.fromJsonMap(item)));

    return songs;
  }

  static Future fetchFollowArtist(String idUser) async {
    final body = {
      'user_id': idUser,
    };
    var response = await htp
        .post('https://music-server-ryo.herokuapp.com/follows/ls', body: body);

    debugPrint("FOLLOW + " + response.body.toString());

    var res = json.decode(response.body.toString());

    List<Artist> artists = [];

    Artist one;
    res.forEach((item) async {
      one = await fetchArtist(item["artist_id"]);
      artists.add(one);
      debugPrint("GJKDNSDFKSF = " + one.toString());
    });
    debugPrint("GJKDNSDFKSF LENG = " + artists.length.toString());
    return artists;
  }

  static Future deleteFollowArtist(String idUser, String alias) async {
    final body = {
      'user_id': idUser,
      'artist_id': alias,
    };
    var response = await htp
        .post('https://music-server-ryo.herokuapp.com/follows/rm', body: body);

    debugPrint("REMOVE + " + response.body.toString());

    return response.body.toString();
  }

  static Future addFollowArtist(String idUser, String alias) async {
    final body = {
      'user_id': idUser,
      'artist_id': alias,
    };
    var response = await htp
        .post('https://music-server-ryo.herokuapp.com/follows/', body: body);

    debugPrint("REMOVE + " + response.body.toString());

    return response.body.toString();
  }

  static Future fetchCommentSong(String idSong) async {
    final body = {
      'music_id': idSong,
    };
    var response = await htp
        .post('https://music-server-ryo.herokuapp.com/comments/ls', body: body);

    debugPrint("COMMENT            + " + response.body.toString());

    var res = json.decode(response.body.toString());

    List<Comment> comments = [];

    res.forEach((item) {
      comments.add(Comment.fromJsonMap(item));
    });

    return comments;
  }

  static Future addCommentSong(
      String idSong, String username, String content) async {
    final body = {
      'music_id': idSong,
      'user_id': username,
      'content': content,
    };
    var response = await htp
        .post('https://music-server-ryo.herokuapp.com/comments/', body: body);

    return response.body.toString();
  }
}
