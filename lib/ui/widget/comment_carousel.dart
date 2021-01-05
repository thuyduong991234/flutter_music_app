import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:provider/provider.dart';

class CommentCarousel extends StatefulWidget {
  @override
  _CommentCarouselState createState() => _CommentCarouselState();
}

class _CommentCarouselState extends State<CommentCarousel> {
  Widget _buildCommentLeft(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(bottom: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90.0),
                child: Container(
                    width: 35,
                    height: 35,
                    child: Image(
                        image: CachedNetworkImageProvider(
                            "https://ui-avatars.com/api/?name=" +
                                comment.user_name +
                                "&size=128&background=random"))),
              )),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    comment.user_name,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    comment.content,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentRight(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor.withAlpha(50),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      comment.user_name,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      comment.content,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                      textDirection: TextDirection.rtl,
                      overflow: TextOverflow.clip,
                    ),
                  ]),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Container(
              padding: EdgeInsets.only(bottom: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90.0),
                child: Container(
                    width: 35,
                    height: 35,
                    child: Image(
                        image: CachedNetworkImageProvider(
                            "https://ui-avatars.com/api/?name=" +
                                comment.user_name +
                                "&size=128&background=random"))),
              )),
        ],
      ),
    );
  }

  TextEditingController _text = new TextEditingController();

  _showListCommand() {
    showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          SongModel songModel = Provider.of(context);
          return StatefulBuilder(
            builder: (BuildContext context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            S.of(context).titleComment,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          )),
                      Container(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            songModel.comments != null
                                ? songModel.comments.length.toString() +
                                    " " +
                                    S.of(context).titleComment
                                : "0 " + S.of(context).titleComment,
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: songModel.comments != null
                        ? songModel.comments.length
                        : 0,
                    itemBuilder: (BuildContext context, int index) {
                      if (FirebaseAuth.instance.currentUser == null)
                        return _buildCommentLeft(songModel.comments[index]);
                      else if (songModel.comments[index].user_id ==
                          FirebaseAuth.instance.currentUser.uid)
                        return _buildCommentRight(songModel.comments[index]);
                      else
                        return _buildCommentLeft(songModel.comments[index]);
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                                margin: EdgeInsets.only(left: 20.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withAlpha(50),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: TextFormField(
                                  controller: _text,
                                  onTap: () {},
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: S.of(context).enterComment),
                                ))),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                          onPressed: () {
                            songModel.addComments(
                                FirebaseAuth.instance.currentUser.displayName,
                                _text.text);
                            _text.clear();
                          },
                          iconSize: 30,
                          padding: EdgeInsets.only(
                              right: 20,
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          icon: Icon(Icons.send,
                              color: Theme.of(context).accentColor)),
                    ])),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _showListCommand(),
        icon: Icon(
          Icons.comment,
          color: Colors.grey,
          size: 20.0,
        ));
  }
}
