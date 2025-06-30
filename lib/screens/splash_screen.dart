import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../utils/app_colors.dart';
import '../widgets/sena_logo.dart';
import '../models/models.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    final box = Hive.box<Aprendiz>('aprendicesBox');
    final aprendiz = box.values.isNotEmpty ? box.values.first : null;

    if (mounted) {
      if (aprendiz != null) {
        Navigator.pushReplacementNamed(context, '/inicio', arguments: aprendiz);
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.senaGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const SenaLogo(
                width: 170,
                height: 170,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Carnet Digital',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sistema de Identificación Digital',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}