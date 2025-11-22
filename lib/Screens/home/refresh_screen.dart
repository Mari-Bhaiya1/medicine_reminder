import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_adaptive_progress_hub/overlay_adaptive_progress_hub.dart';

import '../../database/respository.dart';
import '../LoginScreens/round_button.dart';

class RefreshScreen extends StatefulWidget {

  static String id='Refresh_Screen';

  const RefreshScreen({super.key});

  @override
  State<RefreshScreen> createState() => _RefreshScreenState();
}

class _RefreshScreenState extends State<RefreshScreen> {
  bool _showSpinner = false;
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
                title: 'Upload to Cloud',
                colour: Colors.blueAccent,
                onPress: () async {
                  setState(() {
                    _showSpinner = true;
                  });
                  try {
                    await _respository.syncToFirebase();
                    Fluttertoast.showToast(msg: "Data uploaded successfully!");
                  } catch (e) {
                    Fluttertoast.showToast(msg: "Error: $e");
                  } finally {
                    if (mounted) {
                      setState(() {
                        _showSpinner = false;
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 12.0),
              RoundButton(
                title: 'Download from Cloud',
                colour: Colors.green,
                onPress: () async {
                  setState(() {
                    _showSpinner = true;
                  });
                  try {
                    await _respository.syncFromFirebase();
                    Fluttertoast.showToast(msg: "Data downloaded successfully!");
                  } catch (e) {
                    Fluttertoast.showToast(msg: "Error: $e");
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
                height: 24.0,
              ),
              RoundButton(
                title: 'Back',
                colour: Colors.grey,
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
