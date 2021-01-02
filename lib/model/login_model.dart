import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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
        print('User is signed in!');
      }
    });
  }

  login() async {
    try {
      debugPrint("vô la" + this.email.trim());
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: this.email.trim(), password: this.pwd.trim());
      if (userCredential != null) {
        debugPrint("vô la");
        this.user = userCredential;
        print("LOGINIIGIGIG" + this.user.toString());
        return "ok";
      } else
        debugPrint("cre" + userCredential.toString());
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
    /*AuthCredential authCredential = EmailAuthProvider.credential(
      email: user.user.email,
      password: pwd.trim(),
    );
    try {
      UserCredential userCredential =
          await user.user.reauthenticateWithCredential(authCredential);
      if (userCredential != null) {
        debugPrint("vô la");
        this.user = userCredential;
        print("LOGINIIGIGIG" + this.user.toString());
        return "ok";
      } else
        debugPrint("cre" + userCredential.toString());
    } on FirebaseAuthException catch (e) {
      return e.code;
    }*/
    try {
      debugPrint("vô la" + this.email.trim());
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: this.email.trim(), password: pwd.trim());
      if (userCredential != null) {
        debugPrint("vô la");
        this.user = userCredential;
        print("LOGINIIGIGIG" + this.user.toString());
        return "ok";
      } else
        debugPrint("cre" + userCredential.toString());
    } on FirebaseAuthException catch (e) {
      debugPrint("cre" + e.toString());
      if (e.code == 'user-not-found') {
        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user.";
      }
    }
  }

  update({String email, String name, String pwd}) async {
    debugPrint(email);
    debugPrint(user.user.email);
    debugPrint(pwd);
    if (email != null && email != user.user.email && email.isNotEmpty) {
      try {
        await user.user.updateEmail(email);
        FirebaseAuth.instance.currentUser.reload();
        curUser = FirebaseAuth.instance.currentUser;
        debugPrint("email update" + FirebaseAuth.instance.currentUser.email);
        debugPrint("email update" + curUser.email);
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

    await user.user.reload();
    debugPrint("email" + user.user.email);
    debugPrint("password" + user.user.email);

    notifyListeners();

    return "ok";
  }
}
