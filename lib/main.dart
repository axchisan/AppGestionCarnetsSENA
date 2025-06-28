import 'package:flutter/material.dart';
import 'package:sena_gestion_carnets/screens/home_screen.dart';
import 'package:sena_gestion_carnets/screens/login_screen.dart';
import 'package:sena_gestion_carnets/screens/splash_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENA Carnets virtuales',
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
      home: const LoginScreen(),
    );
  }
}
