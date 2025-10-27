import 'package:flutter/material.dart';
import 'package:shree_ram_staff/screens/CommonScreens/auth/login_screen.dart';
import 'package:shree_ram_staff/screens/SubUser/Home/home_screen.dart';
import 'package:shree_ram_staff/screens/SuperUser/Home/super_user_home_screen.dart';
import 'package:shree_ram_staff/utils/app_routes.dart';
import 'package:shree_ram_staff/utils/pref_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefUtils.isLoggedIn();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Broker App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      builder: (context, child) {
        // Override system font scaling for the entire app
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      home: const SplashScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<bool> checkLogin() async {
    return await PrefUtils.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading while checking login status
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          // If logged in, show MainScreen, else LoginScreen
          bool isLoggedIn = snapshot.data ?? false;
          return isLoggedIn
              //? const HomeScreen()
              ? const SuperUserHomeScreen()
              : const LoginScreen();
        }
      },
    );
  }
}
