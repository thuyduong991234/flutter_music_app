import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_music_app/provider/view_state_model.dart';

class LoginStateModel extends ViewStateSingleModel<LoginFirebase> {
  LoginFirebase fb;

  LoginStateModel({this.fb});

  Future<LoginFirebase> loadData() async {
    fb.reload();
    setIdle();
    return fb;
  }
}

class LoginFirebase with ChangeNotifier {
  String email;
  String pwd;
  UserCredential user;
  User curUser;

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
        //   this.curUser = user;
        reload();
        print('User is signed in!');
      }
    });
  }

  login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: this.email.trim(), password: this.pwd.trim());
      if (userCredential != null) {
        debugPrint("LOG: Login success!");
        refresh(userCredential);
        return "ok";
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("cre" + e.toString());
      if (e.code == 'user-not-found') {
        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user.";
      }
    }
  }

  reauth(String pwd) async {
    debugPrint("LOG: REAUTHING");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: curUser.email, password: pwd.trim());
      if (userCredential != null) {
        refresh(userCredential);
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

  /*
   *
   */
  reload() async {
    await FirebaseAuth.instance.currentUser.reload();
    this.curUser = FirebaseAuth.instance.currentUser;
  }

  refresh(UserCredential newUserCre) {
    this.user = newUserCre;
    this.curUser = newUserCre.user;
  }

  update({String email, String name, String pwd}) async {
    debugPrint("LOG: UPDATING");
    if (email != null && email != user.user.email && email.isNotEmpty) {
      try {
        await user.user.updateEmail(email);
      } on FirebaseAuthException catch (e) {
        debugPrint(e.toString());
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
      await user.user.updatePassword(pwd);
    }

    reload();

    notifyListeners();

    return "ok";
  }

  register(String name, String email, String pwd) async {
    try {
      debugPrint("VOOOOOOOO" + email.toString());
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: pwd.trim());
      await userCredential.user.updateProfile(displayName: name);
      return 'ok';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();

    this.user = null;
    this.curUser = null;
  }
}
