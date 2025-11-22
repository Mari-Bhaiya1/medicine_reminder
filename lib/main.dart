import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicinereminder/Screens/LoginScreens/login.dart';
import 'package:medicinereminder/Screens/LoginScreens/signup.dart';
import 'package:medicinereminder/Screens/add_new_medicine/add_new_medicine.dart';
import 'package:medicinereminder/Screens/home/home.dart';
import 'package:medicinereminder/Screens/home/refresh_screen.dart';
import 'package:medicinereminder/Screens/splash_Screen.dart';
import 'package:medicinereminder/Screens/welcome/welcome.dart';
import 'package:medicinereminder/logout_Screen/logout_Screen.dart';
import 'package:medicinereminder/notifications/notification_permission.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null && kDebugMode) {
    print('notification payload: $payload');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );

  await requestNotificationPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(7, 190, 200, 1),
        fontFamily: "Poppins",
        textTheme: TextTheme(
          displayLarge: ThemeData.light().textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 38.0,
                fontFamily: "Poppins",
              ),
          headlineMedium: ThemeData.light().textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 17.0,
                fontFamily: "Poppins",
              ),
          displaySmall: ThemeData.light().textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
                fontFamily: "Poppins",
              ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignupScreen.id: (context) => const SignupScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        AddNewMedicine.id: (context) => const AddNewMedicine(),
        LogoutScreen.id: (context) => const LogoutScreen(),
        RefreshScreen.id: (context) => const RefreshScreen(),
      },
    );
  }
}
