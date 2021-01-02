import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommentCarousel extends StatefulWidget {
  @override
  _CommentCarouselState createState() => _CommentCarouselState();
}

class _CommentCarouselState extends State<CommentCarousel> {
  final comment = TextEditingController();

  Widget _buildCommentLeft() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(bottom: 45),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90.0),
                child: Container(
                    width: 35,
                    height: 35,
                    child: Image(
                        image: CachedNetworkImageProvider(
                            "https://ui-avatars.com/api/?name=John+Doe&size=128"))),
              )),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Username",
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
                    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
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

  Widget _buildCommentRight() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Username",
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
                    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                    textDirection: TextDirection.rtl,
                    overflow: TextOverflow.clip,
                  ),
                ]),
          ),
          SizedBox(
            width: 20.0,
          ),
          Container(
              padding: EdgeInsets.only(bottom: 45),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90.0),
                child: Container(
                    width: 35,
                    height: 35,
                    child: Image(
                        image: CachedNetworkImageProvider(
                            "https://ui-avatars.com/api/?name=John+Doe&size=128"))),
              )),
        ],
      ),
    );
  }

  _showListCommand() {
    showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
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
                            "Bình luận",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          )),
                      Container(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            "2 comments",
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
                    itemCount: 8,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 4)
                        return _buildCommentRight();
                      else
                        return _buildCommentLeft();
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
                                child: TextField(
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
                                      hintText: "Bình luận..."),
                                ))),
                      ),
                      SizedBox(width: 10),
                      IconButton(
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
