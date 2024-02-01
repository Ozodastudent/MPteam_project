import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mp_team_project/core/app_colors.dart';
import 'package:mp_team_project/models/utils.dart';
import 'package:mp_team_project/pages/auth/sign_up_page.dart';
import 'package:mp_team_project/pages/main/header_page.dart';
import 'package:mp_team_project/pages/views/validate_textField.dart';
import 'package:mp_team_project/services/auth_service.dart';
import 'package:mp_team_project/services/pref_service.dart';
import 'package:mp_team_project/widgets/glassmorphism_widget.dart';

class SignInPage extends StatefulWidget {
  static const String id = "sign_in_page";
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with InputValidation {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formGlobalKey = GlobalKey();

  void callDoSignUp() {
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }

  bool isLoading = false;

  void _openHomePage() async {
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if(email.isEmpty || password.isEmpty) {
      Utils.showToast(context, "Please complete all the fields");
      return;
    }

    setState(() {
      isLoading = true;
    });

    await AuthService.signInUser(email, password).then((response) {
      _getFirebaseUser(response);
    });
  }

  void _getFirebaseUser(Map<String, User?> map) async {
    setState(() {
      isLoading = false;
    });

    if(!map.containsKey("SUCCESS")) {
      if(map.containsKey("user-not-found")) Utils.showToast(context, "No user found for that email.");
      if(map.containsKey("wrong-password")) Utils.showToast(context, "Wrong password provided for that user.");
      if(map.containsKey("ERROR")) Utils.showToast(context, "Check Your Information.");
      return;
    }

    User? user = map["SUCCESS"];
    if(user == null) return;

    await Prefs.store(StorageKeys.UID, user.uid).then((value) {
      Navigator.pushNamedAndRemoveUntil(context, HeaderPage.id, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(225, 48, 110, 1.0),
                      Color.fromRGBO(255, 0, 71, 1)
                    ]
                )
            ),
            child: Form(
              key: formGlobalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        // #text
                        const Text('Photoidea', style: TextStyle(fontFamily: 'Billabong', fontSize: 25, color: AppColors.white),),

                        const SizedBox(
                          height: 25,
                        ),

                        // #email field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: GlassMorphism(
                            start: 0.4,
                            end: 0.4,
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email',
                                contentPadding: EdgeInsets.only(left: 15, right: 15),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        // #password field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: GlassMorphism(
                            start: 0.4,
                            end: 0.4,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  contentPadding: EdgeInsets.only(left: 15, right: 15)
                              ),
                            ),
                          ),
                        ),

                        //
                        const SizedBox(
                          height: 12,
                        ),

                        // #button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: GlassMorphism(
                            start: 0.0,
                            end: 0.0,
                            child: MaterialButton(
                              onPressed: (){
                                if(isEmailValid(emailController.text.trim()) && isPasswordValid(passwordController.text.trim())) {
                                  _openHomePage();
                                } else {
                                  Utils.showToast(context, "Email or password invalid");
                                }
                              },
                              minWidth: MediaQuery.of(context).size.width,
                              child: const Text("Sign In"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: callDoSignUp,
                              child: const Text("Sign Up", style: TextStyle(color: AppColors.white)),
                            )
                          ],
                        )
                    ),
                  )
                ],
              ),
            ),
          ),

          isLoading ? const Center(
            child:  CircularProgressIndicator(),
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
