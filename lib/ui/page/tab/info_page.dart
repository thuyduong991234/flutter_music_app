import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/login_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/ui/page/tab/mine_page.dart';
import 'package:flutter_music_app/ui/page/tab/tab_navigator.dart';
import 'package:flutter_music_app/ui/widget/bezierContainer.dart';
import 'package:provider/provider.dart';

class InfoPage extends StatefulWidget {
  InfoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String email = "";
  String pwd = "";
  String name = "";
  String oldEmail = "";
  String oldPwd = "";
  String oldName = "";
  User user;
  String err;
  TextEditingController emailC = new TextEditingController();
  TextEditingController pwdC = new TextEditingController();
  TextEditingController nameC = new TextEditingController();
  initState() {
    super.initState();
  }

  _showEnterPassword() {
    String pass = "";
    String err = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, setState) => AlertDialog(
                    content: Container(
                        height: 150,
                        child: Wrap(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Xác minh mật khẩu",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ],
                            ),
                            SizedBox(height: 60),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    )),
                                Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 10),
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: Text("Password",
                                          style: TextStyle(fontSize: 16))),
                                ),
                              ],
                            ),
                            TextField(
                              onChanged: (text) {
                                pass = text;
                              },
                              obscureText: true,
                            ),
                            if (err != null || err != "ok")
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  err ?? "",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        )),
                    actions: [
                      MaterialButton(
                          onPressed: () async {
                            LoginFirebase fb = Provider.of(context);
                            var ret = await fb.reauth(pass);
                            if (ret == "ok") {
                              //debugPrint("PASS = " + ret);
                              var ret1 = await fb.update(
                                  email: this.email,
                                  pwd: this.pwd,
                                  name: this.name);
                              if (ret1 != "ok") {
                                setState(() {
                                  err = ret1;
                                });
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabNavigator(
                                              index: 3,
                                            )));
                              }
                            }
                          },
                          child: Text("ĐỒNG Ý",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor)))
                    ],
                  ));
        });
  }

  Widget _backButton() {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabNavigator(
                            index: 3,
                          )))
            },
          ),
          Text(
            "Thông tin tài khoản",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _entryField(String title,
      {bool isPassword = false, bool isEmail = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              //controller: isPassword ? pwdC : isEmail ? emailC : nameC,
              initialValue: isPassword ? oldPwd : isEmail ? oldEmail : oldName,
              onChanged: (value) {
                if (isPassword) {
                  setState(() {
                    pwd = value;
                  });
                } else if (isEmail) {
                  setState(() {
                    email = value;
                  });
                } else {
                  setState(() {
                    name = value;
                  });
                }
              },
              obscureText: isPassword,
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
              ))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
        onTap: () async {
          _showEnterPassword();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              color: Theme.of(context).accentColor),
          child: Text(
            "Cập nhật",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _title() {
    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.width * 0.25,
          child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  "https://ui-avatars.com/api/?name=John+Doe&size=128&background=random"))),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username"),
        _entryField("Email id", isEmail: true),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    LoginFirebase fb = Provider.of(context);
    //debugPrint("LOG: INFO= name= " + fb.curUser.toString());
    setState(() {
      oldEmail = fb.curUser.email;
      oldName = fb.curUser.displayName;
      oldPwd = "";
    });

    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          height: height,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .2),
                        _title(),
                        SizedBox(
                          height: 50,
                        ),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                        SizedBox(height: height * .14),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 40, left: 0, child: _backButton()),
              ],
            ),
          )),
    );
  }
}
