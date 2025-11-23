import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicinereminder/Screens/LoginScreens/login.dart';
import 'package:medicinereminder/database/respository.dart';
import 'package:medicinereminder/notifications/notification_permission.dart';
import 'package:overlay_adaptive_progress_hub/overlay_adaptive_progress_hub.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LoginScreens/round_button.dart';

class LogoutScreen extends StatefulWidget {
  static String id = 'Logout_Screen';

  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  bool _showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final Respository _respository = Respository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OverlayAdaptiveProgressHub(
        inAsyncCall: _showSpinner,
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
              const SizedBox(height: 48.0),
              RoundButton(
                title: 'Log Out',
                colour: Colors.redAccent,
                onPress: () async {
                  setState(() {
                    _showSpinner = true;
                  });

                  try {
                    // 1. Sync data to Firebase
                    await _respository.syncToFirebase();
                    // 2. Cancel all pending notifications using the global plugin
                    await flutterLocalNotificationsPlugin.cancelAll();
                    // 3. Clear local data
                    await _respository.clearLocalData();
                    // 4. Sign out from Firebase Auth
                    await _auth.signOut();

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                    );

                    Fluttertoast.showToast(
                      msg: "Logout Successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: "Something went wrong: $e",
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                    );
                  } finally {
                    if (mounted) {
                      setState(() {
                        _showSpinner = false;
                      });
                    }
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              RoundButton(
                title: 'Back',
                colour: Colors.lightBlueAccent,
                onPress: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
