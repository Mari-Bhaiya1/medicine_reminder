import 'package:flutter/material.dart';
import 'package:medicinereminder/Screens/LoginScreens/login.dart';
import 'package:medicinereminder/Screens/welcome/titleandmessage.dart';
import 'package:medicinereminder/helper/platform_button.dart';

class WelcomeScreen extends StatelessWidget {
  static String id = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double deviceheight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: deviceheight * 0.1),
              Image.asset(
                'assets/images/welcome_image.png',
                width: double.infinity,
                height: deviceheight * 0.4,
              ),
              SizedBox(height: deviceheight * 0.04),
              TitleandMessage(deviceheight: deviceheight),
              SizedBox(height: deviceheight * 0.03),
              Container(
                height: deviceheight * 0.09,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(left: 35.0, right: 35.0),
                  child: PlatformButton(
                    handle: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    color: Theme.of(context).primaryColor,
                    ButtonChild: FittedBox(
                      child: Text(
                        'Get Started Now',
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
