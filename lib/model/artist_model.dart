import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/view_state_refresh_list_model.dart';
import 'package:flutter_music_app/service/base_repository.dart';

class ListArtistModel extends ViewStateRefreshListModel<Artist> {
  List<Artist> _artists;
  final String input;

  ListArtistModel({this.input});

  List<Artist> get artists => _artists;
  @override
  Future<List<Artist>> loadData({int pageNum}) async {
    List<Future> futures = [];
    futures.add(BaseRepository.fetchSearchType(input, "artist", pageNum));

    var result = await Future.wait(futures);
    _artists = result[0];
    return result[0];
  }
}

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
  String link;

  List<Song> singles;
  List<Song> topSongs;
  List<Song> songs;
  List<Song> albums;
  List<Artist> canLikes;

  Artist.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"] != null ? map["id"] : null,
        name = map["name"] != null ? map["name"] : null,
        realName = map["realname"] != null ? map["realname"] : null,
        birthday = map["birthday"] != null ? map["birthday"] : null,
        national = map["national"] != null ? map["national"] : null,
        cover = map["cover"] != null ? map["cover"] : null,
        thumbnail = map["thumbnail"] != null ? map["thumbnail"] : null,
        biography = map["biography"] != null ? map["biography"] : null,
        follow = map["follow"] != null ? map["follow"] : null,
        link = map["link"] != null ? map["link"] : null;
}
