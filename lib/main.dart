import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'screens/id_card_screen.dart';
import 'screens/device_management_screen.dart';
import 'screens/home_navigation_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const SenaApp());
}

class SenaApp extends StatelessWidget {
  const SenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENA Carnets Virtuales',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: AppColors.senaGreen,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
        ),
      ),
      home: const HomeNavigationScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegistrationScreen(),
        '/inicio': (context) => const HomeScreen(),
        '/carnet': (context) => const IdCardScreen(),
        '/dispositivos': (context) => const DeviceManagementScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
