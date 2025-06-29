import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/sena_logo.dart';

class HomeNavigationScreen extends StatelessWidget {
  const HomeNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header con logo
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: const Column(
                  children: [
                    SenaLogo(
                      width: 200,
                      height: 66,
                      showShadow: false,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Mockups - App Carnets Virtuales SENA',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Navegación entre las diferentes pantallas',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.gray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Grid de opciones
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildNavigationCard(
                      context,
                      'Pantalla de Login',
                      'Inicio de sesión',
                      Icons.login,
                      '/login',
                    ),
                    _buildNavigationCard(
                      context,
                      'Registro',
                      'Crear cuenta nueva',
                      Icons.person_add,
                      '/registro',
                    ),
                    _buildNavigationCard(
                      context,
                      'Carnet Virtual',
                      'Identificación digital',
                      Icons.credit_card,
                      '/carnet',
                    ),
                    _buildNavigationCard(
                      context,
                      'Menú Principal',
                      'Pantalla de inicio',
                      Icons.home,
                      '/inicio',
                    ),
                    _buildNavigationCard(
                      context,
                      'Dispositivos',
                      'Gestión de dispositivos',
                      Icons.devices,
                      '/dispositivos',
                    ),
                    _buildNavigationCard(
                      context,
                      'Splash Screen',
                      'Pantalla de carga',
                      Icons.flash_on,
                      '/splash',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String route,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.senaGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: AppColors.senaGreen,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.gray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
