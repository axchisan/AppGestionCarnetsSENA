import 'package:flutter/material.dart';
import 'package:sena_gestion_carnets/widgets/sena_logo.dart';
import '../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.senaGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const SenaLogo(
                width: 170,
                height: 170,
                showShadow: false,
              ),
            ),
            const SizedBox(height: 40),

            const Text(
              'Sistema de Identificación Digital',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(255, 255, 255, 0.9),
              ),
            )
          ],
        ),
      ),
    );
  }
}