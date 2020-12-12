import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_music_app/config/net/base_api.dart';
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
  static String url =
      "/home?ctime=1607767682074&sig=8bec950bdd34189d605dfd46233e5f69a9f4cb3ab4693ecd8a1aa3c22dfc793ab28cb0c2a927383c14fb631c23386b77cba955077009cc97295b7e98b252d5d9&api_key=38e8643fb0dc04e8d65b99994d3dafff";
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
    debugPrint(response.toString());
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
      default:
    }
  }
}
