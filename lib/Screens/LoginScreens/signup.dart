import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicinereminder/Screens/LoginScreens/login.dart';
import 'package:medicinereminder/Screens/LoginScreens/round_button.dart';
import 'package:medicinereminder/Screens/home/home.dart';
import 'package:medicinereminder/helper/constants.dart';
import 'package:overlay_adaptive_progress_hub/overlay_adaptive_progress_hub.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'signup_screen';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
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

              Text('SignUp',
              style: kSendButtonTextStyle.copyWith(fontSize: 30.0,color: Colors.blueAccent),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDesign(borderColor: Colors.blueAccent, hintTexts: 'Enter Your Email'),
                style: kTextStyle,
              ),
              const SizedBox(height: 8.0),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                style: kTextStyle,
                decoration: kTextFieldDesign(borderColor: Colors.blueAccent, hintTexts: 'Enter Your Password')
              ),
              const SizedBox(height: 24.0),
              RoundButton(
                title: 'Sign Up',
                colour: Colors.blueAccent,
                onPress: () async {
                  setState(() {
                    showSpinner = true;
                  });

                  try {
                    final currentUser = _auth.currentUser;
                    if (currentUser != null) {
                      Fluttertoast.showToast(
                        msg: "Already logged in. Redirecting to home screen...",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.orange,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (Route<dynamic> route) => false,
                      );
                      return;
                    }

                    if (validateForm(email!, password!)) {
                      final userCredential =
                      await _auth.createUserWithEmailAndPassword(
                        email: email!,
                        password: password!,
                      );

                      if (userCredential.user != null) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true);

                        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);

                        Fluttertoast.showToast(
                          msg: "Signup Successfully",
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
                  } catch (e) {
                    print('Signup failed: $e');
                    Fluttertoast.showToast(
                      msg: "Signup failed: $e",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      fontSize: 16.0,
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
                  const Text("Already Have  Account...",style: TextStyle(fontSize: 10.0,fontFamily: 'Poppins',color: Colors.black),),
                  TextButton(onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                      child: const Text("Login",style: TextStyle(fontSize: 15.0,fontFamily: 'Poppins',color: Colors.blueAccent),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
