import 'package:flutter/material.dart';
import 'package:pinterestmobile/di.dart';
import 'package:pinterestmobile/pages/main/account_page.dart';
import 'package:pinterestmobile/pages/main/home_page.dart';
import 'package:pinterestmobile/pages/main/header_page.dart';
import 'package:pinterestmobile/pages/main/search_page.dart';
import 'package:pinterestmobile/pages/splash/splash_page.dart';

import 'pages/auth/sign_in_page.dart';
import 'pages/auth/sign_up_page.dart';

void main() async {
  await setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pinterest Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
      routes: {
        SplashPage.id: (context) => const SplashPage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        HeaderPage.id: (context) => const HeaderPage(),
        HomePage.id: (context) => const HomePage(),
        SearchPage.id: (context) => const SearchPage(),
        AccountPage.id: (context) => const AccountPage(),
      },
    );
  }

}