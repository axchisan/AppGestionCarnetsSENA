import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../utils/app_colors.dart';
import '../widgets/sena_logo.dart';
import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  final Aprendiz? aprendiz;

  const HomeScreen({super.key, this.aprendiz});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Aprendiz>('aprendicesBox');
    final primerAprendiz = aprendiz ?? (box.values.isNotEmpty ? box.values.first : null);

    void _logout() async {
      await box.clear(); // Limpiar sesión
      Navigator.pushReplacementNamed(context, '/splash'); // Volver a SplashScreen
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: AppColors.black),
          onPressed: () {
            // Aquí podrías abrir un drawer o menú con opción de cerrar sesión
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Cerrar Sesión'),
                content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      _logout();
                      Navigator.pop(context);
                    },
                    child: const Text('Cerrar Sesión', style: TextStyle(color: AppColors.red)),
                  ),
                ],
              ),
            );
          },
        ),
        title: const SenaLogo(
          width: 120,
          height: 40,
          showShadow: false,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Bienvenido, ${primerAprendiz?.nombreCompleto ?? 'Invitado'}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (primerAprendiz != null) {
                          Navigator.pushNamed(context, '/carnet', arguments: primerAprendiz);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No hay aprendices registrados')),
                          );
                        }
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Programa Actual',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            primerAprendiz?.programaFormacion ?? 'No disponible',
                            style: const TextStyle(
                              color: AppColors.gray,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ficha: ${primerAprendiz?.numeroFicha ?? 'N/A'}',
                            style: const TextStyle(
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
                  primerAprendiz,
                ),
                _buildBottomNavItem(
                  context,
                  Icons.devices,
                  'Dispositivos',
                  '/dispositivos',
                  primerAprendiz,
                ),
                _buildBottomNavItem(
                  context,
                  Icons.close,
                  'Cerrar',
                  '', // Sin ruta
                  null,
                  onTap: () => exit(0), // Cerrar la app
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
    Aprendiz? aprendiz, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () {
        if (route.isEmpty) return;
        if (route == '/login') {
          Navigator.pushReplacementNamed(context, route);
        } else if (aprendiz != null) {
          Navigator.pushNamed(context, route, arguments: aprendiz);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No hay aprendices registrados')),
          );
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