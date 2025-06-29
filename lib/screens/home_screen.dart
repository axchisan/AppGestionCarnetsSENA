import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/sena_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Logo SENA
                  const SenaLogo(
                    width: 120,
                    height: 40,
                    showShadow: false,
                  ),
                  const SizedBox(height: 24),

                  // Saludo
                  const Text(
                    'Bienvenido, Juan Carlos',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Notificación
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.senaGreen.withOpacity(0.1),
                      border: Border.all(color: AppColors.senaGreen),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: AppColors.senaGreen,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tu carnet virtual está listo para usar',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Contenido principal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Tarjeta de carnet virtual
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/carnet');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.senaGreen, AppColors.senaGreenDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.senaGreen.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tu Carnet Virtual',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Toca para ver tu identificación',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.credit_card,
                              color: AppColors.white,
                              size: 48,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Información del programa
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Programa Actual',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Análisis y Desarrollo de Sistemas de Información',
                            style: TextStyle(
                              color: AppColors.gray,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Ficha: 2758936',
                            style: TextStyle(
                              color: AppColors.gray,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Barra de navegación inferior
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.senaGreen,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(
                  context,
                  Icons.credit_card,
                  'Carnet',
                  '/carnet',
                ),
                _buildBottomNavItem(
                  context,
                  Icons.devices,
                  'Dispositivos',
                  '/dispositivos',
                ),
                _buildBottomNavItem(
                  context,
                  Icons.logout,
                  'Salir',
                  '/login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return GestureDetector(
      onTap: () {
        if (route == '/login') {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.white,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
