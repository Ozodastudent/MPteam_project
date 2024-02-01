import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mp_team_project/core/app_colors.dart';
import 'package:mp_team_project/models/user_model.dart';
import 'package:mp_team_project/models/utils.dart';
import 'package:mp_team_project/pages/auth/sign_in_page.dart';
import 'package:mp_team_project/pages/main/header_page.dart';
import 'package:mp_team_project/pages/views/validate_textField.dart';
import 'package:mp_team_project/services/auth_service.dart';
import 'package:mp_team_project/services/data_service.dart';
import 'package:mp_team_project/services/pref_service.dart';
import 'package:mp_team_project/widgets/glassmorphism_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static const String id = "sign_up_page";
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with InputValidation {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


  bool isLoading = false;

  void _openSignInPage() async {
    String fullName = fullNameController.text.trim().toString();
    String email = emailController.text.trim().toString();
    String confirmPassword = confirmPasswordController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if((email.isEmpty || password.isEmpty || fullName.isEmpty || confirmPassword.isEmpty) && password == confirmPassword) {
      Utils.showToast(context, "Please complete all the fields");
      return;
    }

    setState(() {
      isLoading = true;
    });

    var modelUser = Users(fullName: fullName, email: email, password: password);
    await AuthService.signUpUser(modelUser).then((response) {
      _getFirebaseUser(response, modelUser);
    });
  }

  void _getFirebaseUser(Map<String, User?> map, Users users) async {
    setState(() {
      isLoading = false;
    });

    if(!map.containsKey("SUCCESS")) {
      if(map.containsKey("weak-password")) Utils.showToast(context, "The password provided is too weak.");
      if(map.containsKey("email-already-in-use")) Utils.showToast(context, "The account already exists for that email.");
      if(map.containsKey("ERROR")) Utils.showToast(context, "Check Your Information");
      return;
    }

    User? user = map["SUCCESS"];
    if(user == null) return;

    await Prefs.store(StorageKeys.UID, user.uid);
    users.uid = user.uid;

    await DataService.storeUser(users).then((value) {
      Navigator.pushNamedAndRemoveUntil(context, SignInPage.id, (route) => false);
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
                      const Text(
                        'Photoidea',
                        style: TextStyle(fontFamily: 'Billabong', fontSize: 25, color: AppColors.white),),

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
                            controller: fullNameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Fullname',
                                contentPadding: EdgeInsets.only(left: 15, right: 15)
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
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email',
                                contentPadding: EdgeInsets.only(left: 15, right: 15)
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
                            obscureText: true,
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                contentPadding: EdgeInsets.only(left: 15, right: 15)
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
                            controller: confirmPasswordController,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Confirm Password',
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
                              if(isEmailValid(emailController.text.trim())
                                  && isPasswordValid(passwordController.text.trim())
                                  && isConfirmPasswordValid(confirmPasswordController.text.trim())) {
                                _openSignInPage();
                              } else {
                                Utils.showToast(context, "Email or password invalid");
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            child: const Text("Sign Up"),
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
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: (){
                              Navigator.pushReplacementNamed(context, SignInPage.id);
                            },
                            child: const Text("Sign In", style: TextStyle(color: AppColors.white),),
                          )
                        ],
                      )
                  ),
                )
              ],
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
