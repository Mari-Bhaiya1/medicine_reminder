import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicinereminder/Screens/LoginScreens/signup.dart';
import 'package:medicinereminder/Screens/home/home.dart';
import 'package:medicinereminder/database/respository.dart';
import 'package:medicinereminder/helper/constants.dart';
import 'package:overlay_adaptive_progress_hub/overlay_adaptive_progress_hub.dart';
import 'package:medicinereminder/Screens/LoginScreens/round_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final Respository _respository = Respository();
  String? email;
  String? password;

  bool validateForm(String email, String password) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      print("Please enter a valid email address");
      return false;
    }
    if (password.isEmpty || password.length < 6) {
      print("Password must be at least 6 characters long");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OverlayAdaptiveProgressHub(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('assets/images/welcome_image.png'),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text('Login',
                  style: kSendButtonTextStyle.copyWith(
                      fontSize: 30.0, color: Colors.lightBlueAccent),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10.0),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  style: kTextStyle,
                  decoration: kTextFieldDesign(
                      borderColor: Colors.lightBlueAccent,
                      hintTexts: 'Enter Your Email')),
              const SizedBox(height: 8.0),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDesign(
                      borderColor: Colors.lightBlueAccent,
                      hintTexts: 'Enter Your Password'),
                  style: kTextStyle),
              const SizedBox(height: 24.0),
              RoundButton(
                title: 'Log In',
                colour: Colors.lightBlueAccent,
                onPress: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    if (validateForm(email!, password!)) {
                      final userCredential =
                          await _auth.signInWithEmailAndPassword(
                        email: email!,
                        password: password!,
                      );
                      if (userCredential.user != null) {
                        await _respository.syncFromFirebase();
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true);

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (Route<dynamic> route) => false,
                        );
                        Fluttertoast.showToast(
                          msg: "Login Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.greenAccent,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Check the fields again",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      Fluttertoast.showToast(
                        msg: "No user found for that email.",
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                      );
                    } else if (e.code == 'wrong-password') {
                      Fluttertoast.showToast(
                        msg: "Wrong password provided.",
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "Login failed: ${e.message}",
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                      );
                    }
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: "Something went wrong: $e",
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                    );
                  } finally {
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Don\'t have an account?",
                      style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Poppins',
                          color: Colors.black)),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignupScreen.id);
                      },
                      child: const Text("Sign Up",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Poppins',
                              color: Colors.lightBlueAccent))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
