import 'package:flutter_music_app/model/song_model.dart';

class Artist {
  String id;
  String name;
  String realName;
  String birthday;
  String national;
  int follow;
  String cover;
  String thumbnail;
  String biography;

  List<Song> songs;
  List<Song> albums;

  Artist.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        realName = map["realname"],
        birthday = map["birthday"],
        national = map["national"],
        cover = map["cover"],
        thumbnail = map["thumbnail"],
        biography = map["biography"],
        songs = map["sections"][0]["items"]
            .forEach((item) => Song.fromJsonMap(item)),
        albums = map["sections"][2]["items"]
            .forEach((item) => Song.fromJsonMap(item));
}
