import 'package:flutter/material.dart';
import 'screens/common/login_screen.dart';
import 'screens/common/splash_screen.dart';
import 'screens/common/profile_screen.dart';
import 'screens/professional/certificate_management.dart';
// import 'screens/common/analytics_screen.dart';

// Import controllers
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/user_controller.dart'; // Import UserController
import 'controllers/analytics_controller.dart';
import 'controllers/expenses_controller.dart';
import 'controllers/meetings_controller.dart';
import '../../controllers/convert_controller.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => UserController()), // Add UserController
        ChangeNotifierProvider(create: (_) => AnalyticsController()),
        ChangeNotifierProvider(create: (_) => MeetingsController()),
        ChangeNotifierProvider(create: (_) => ConvertController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BENJI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashWrapper(),
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authController = Provider.of<AuthController>(context, listen: false);

    // Wait for the login status to be verified
    await Future.delayed(const Duration(seconds: 3));

    if (authController.isLoggedIn) {
      // Redirect to Profile Screen if the user is logged in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfileScreen(), // Profile screen to load if logged in
        ),
      );
    } else {
      // Redirect to Login Screen if the user is not logged in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
