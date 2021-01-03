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
  List<Artist> relatedArtists;

  Artist(
      {this.id,
      this.name,
      this.realName,
      this.birthday,
      this.national,
      this.follow,
      this.cover,
      this.thumbnail,
      this.biography,
      this.link,
      this.singles,
      this.topSongs,
      this.songs,
      this.albums,
      this.relatedArtists});

  factory Artist.fromJsonMap(Map<String, dynamic> map) {
    List<Song> songs = [];
    List<Song> albums = [];
    List<Artist> artists = [];
    if (map["sections"] != null) {
      //get correct list for each section by sectionType
      map["sections"].forEach((section) {
        switch (section["sectionType"]) {
          case "song":
            section["items"]
                .forEach((song) => songs.add(Song.fromJsonMap(song)));
            break;
          case "playlist":
            section["items"]
                .forEach((album) => albums.add(Song.fromJsonMap(album)));
            break;
          case "artist":
            section["items"]
                .forEach((artist) => artists.add(Artist.fromJsonMap(artist)));
            break;
          default:
            break;
        }
      });
    }

    return Artist(
        id: map["id"] ?? null,
        name: map["name"] ?? null,
        realName: map["realName"] ?? null,
        birthday: map["birthday"] ?? null,
        national: map["national"] ?? null,
        follow: map["follow"] ?? null,
        cover: map["cover"] ?? null,
        thumbnail: map["thumbnail"] ?? null,
        biography: map["biography"] ?? null,
        link: map["link"] ?? null,
        singles: [],
        songs: songs.take(3).toList(),
        albums: albums,
        relatedArtists: artists);
  }
}
