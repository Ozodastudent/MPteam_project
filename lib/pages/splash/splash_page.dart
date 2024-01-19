import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinterestmobile/pages/auth/sign_in_page.dart';
import 'package:pinterestmobile/pages/main/header_page.dart';
import 'package:pinterestmobile/services/pref_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const String id = "splash_page";
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  /// from splash to sign in page
  void _openSignInPage() {
    if(mounted) {
      Timer(const Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => _starterPage())));
    }
  }

  // switch pages
  Widget _starterPage() {
    return StreamBuilder<User?> (
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          Prefs.store(StorageKeys.UID, snapshot.data!.uid);
          return const HeaderPage();
        } else {
          Prefs.remove(StorageKeys.UID);
          return const SignInPage();
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _openSignInPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image(
          image: const AssetImage('assets/images/im_pinterest.png'),
          height: MediaQuery.of(context).size.width * 0.2,
          width: MediaQuery.of(context).size.width * 0.2,
        ),
      ),
    );
  }
}