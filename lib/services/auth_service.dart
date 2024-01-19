import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinterestmobile/models/user_model.dart';
import 'package:pinterestmobile/models/utils.dart';
import 'package:pinterestmobile/pages/auth/sign_in_page.dart';
import 'package:pinterestmobile/services/pref_service.dart';


class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  // sign up user
  static Future<Map<String, User?>> signUpUser(Users usersModel) async {
    Map<String, User?> map = {};
    debugPrint("${usersModel.email} ${usersModel.password}");
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: usersModel.email, password: usersModel.password);
      User? user = userCredential.user;
      map = {"SUCCESS": user};
      return map;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        map = {'The password provided is too weak.': null};
      } else if (e.code == 'email-already-in-use') {
        map = {'The account already exists for that email.': null};
      }
    } catch (e) {
      map = {"ERROR $e": null};
    }

    return map;
  }

  // sign in user
  static Future<Map<String, User?>> signInUser(String email, String password) async {
    Map<String, User?> map = {};
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      map = {"SUCCESS": user};
      return map;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        map = {"user-not-found": null};
      } else if (e.code == 'wrong-password') {
        map = {"email-ready-in-use": null};
      }
    } catch (e) {
      map = {"ERROR": null};
    }

    return map;
  }

  // user log out
  static void signOutUser(BuildContext context) async {
    await auth.signOut();
    Prefs.remove(StorageKeys.UID).then((value) {
      Navigator.pushReplacementNamed(context, SignInPage.id);
    });
  }

  // delete account
  static void deleteAccount(BuildContext context) async {
    try {
      auth.currentUser!.delete();
      Prefs.remove(StorageKeys.UID);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SignInPage()), (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        Utils.showToast(context, "The user must re-authenticate before this operation can be executed");
      }
    }
  }

}