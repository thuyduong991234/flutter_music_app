import 'package:flutter/material.dart';

class AppBarCarousel extends StatelessWidget {
  final String title;
  AppBarCarousel({this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25.0,
              color: Colors.grey,
            ),
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
          Text(
            title != null ? title : "",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }
}
