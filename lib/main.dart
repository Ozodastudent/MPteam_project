import 'package:flutter/material.dart';
import 'package:mp_team_project/di.dart';
import 'package:mp_team_project/pages/main/account_page.dart';
import 'package:mp_team_project/pages/main/home_page.dart';
import 'package:mp_team_project/pages/main/header_page.dart';
import 'package:mp_team_project/pages/main/search_page.dart';
import 'package:mp_team_project/pages/splash/splash_page.dart';
import 'pages/auth/sign_in_page.dart';
import 'pages/auth/sign_up_page.dart';

void main() async {
  await setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhotoIdea',
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