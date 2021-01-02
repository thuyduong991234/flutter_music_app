import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/model/song_model.dart';

class AddPlayList extends StatefulWidget {
  final Song song;
  final FavoriteModel favoriteModel;

  AddPlayList(this.song, this.favoriteModel);

  @override
  _AddPlayListState createState() => _AddPlayListState();
}

class _AddPlayListState extends State<AddPlayList> {
  final playlistController = TextEditingController();

  _showFavoriteAddOption() {
    showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Wrap(
                children: <Widget>[
                  widget.favoriteModel.isCollect(widget.song)
                      ? ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.favoriteModel.collect(widget.song);
                            final message = SnackBar(
                                content: Text("Đã xóa khỏi thư viện!"),
                                duration: const Duration(milliseconds: 500));
                            Scaffold.of(context).showSnackBar(message);
                          },
                          leading: Icon(Icons.favorite_border),
                          title: Text("Xóa khỏi thư viện"),
                        )
                      : ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.favoriteModel.collect(widget.song);
                            final message = SnackBar(
                                content: Text("Đã thêm vào thư viện!"),
                                duration: const Duration(milliseconds: 500));
                            Scaffold.of(context).showSnackBar(message);
                          },
                          leading: Icon(Icons.favorite_border),
                          title: Text("Thêm vào thư viện"),
                        ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      _showPlayListAddOption();
                    },
                    leading: Icon(Icons.music_note),
                    title: Text("Thêm vào danh sách phát"),
                  )
                ],
              ),
            ));
  }

  _showPlayListAddOption() {
    showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text("Tạo danh sách phát"),
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String _playlist = "";
                            return StatefulBuilder(
                                builder: (BuildContext context, setState) =>
                                    AlertDialog(
                                      title: Text("Tạo danh sách phát"),
                                      content: Wrap(
                                        children: <Widget>[
                                          TextFormField(
                                              onChanged: (text) {
                                                setState(() {
                                                  _playlist = text;
                                                });
                                              },
                                              controller: playlistController,
                                              decoration: InputDecoration(
                                                  hintText: "Danh sách #1"))
                                        ],
                                      ),
                                      actions: [
                                        MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Bỏ qua",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor))),
                                        MaterialButton(
                                            onPressed: _playlist.isNotEmpty
                                                ? () {
                                                    widget.favoriteModel
                                                        .collect2(
                                                            playlistController
                                                                .text,
                                                            widget.song);
                                                    Navigator.of(context).pop();
                                                    final message = SnackBar(
                                                        content: Text(
                                                            "Đã tạo danh sách phát " +
                                                                playlistController
                                                                    .text +
                                                                "!"),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500));
                                                    Scaffold.of(context)
                                                        .showSnackBar(message);
                                                  }
                                                : null,
                                            child: Text("Đồng ý",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor)))
                                      ],
                                    ));
                          });
                    },
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.favoriteModel.playlists.length,
                      itemBuilder: (BuildContext context, int index) {
                        String name = widget.favoriteModel.playlists.keys
                            .elementAt(index);
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.favoriteModel.collect2(name, widget.song);
                            final message = SnackBar(
                                content: Text(
                                    "Đã thêm vào danh sách phát " + name + "!"),
                                duration: const Duration(milliseconds: 500));
                            Scaffold.of(context).showSnackBar(message);
                          },
                          title: Text(name),
                        );
                      })
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _showFavoriteAddOption(),
        icon: widget.song.link == null
            ? Icon(
                Icons.favorite_border,
                color: Colors.grey,
                size: 20.0,
              )
            : widget.favoriteModel.isCollect(widget.song)
                ? Icon(
                    Icons.favorite,
                    color: Theme.of(context).accentColor,
                    size: 20.0,
                  )
                : Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 20.0,
                  ));
  }
}
