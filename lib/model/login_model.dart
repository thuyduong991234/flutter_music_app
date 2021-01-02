import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginFirebase with ChangeNotifier {
  String email;
  String pwd;
  UserCredential user;

  LoginFirebase({this.email, this.pwd}) {
    listen();
  }

  initData(String email, String pwd) {
    this.email = email;
    this.pwd = pwd;
  }

  listen() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: this.email, password: this.pwd);
      if (userCredential != null) {
        this.user = userCredential;
        print("LOGINIIGIGIG" + this.user.toString());
        return "ok";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user.";
      }
    }
  }

  update({String email, String name, String pwd}) async {
    if (email != null && email != user.user.email && email.isNotEmpty) {
      try {
        await user.user.reauthenticateWithCredential(user.credential);
        await user.user.updateEmail(email);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-emai') {
          return "E:Email Khong hop le";
        }
        if (e.code == 'email-already-in-use') {
          return "E:Email da duoc su dung";
        }
      }
    }

    if (name != null) {
      await user.user.updateProfile(displayName: name);
    }

    if (pwd != null && pwd.isNotEmpty) {
      await user.user.reauthenticateWithCredential(user.credential);
      await user.user.updatePassword(pwd);
    }

    await user.user.reload();

    notifyListeners();

    return "ok";
  }
}
