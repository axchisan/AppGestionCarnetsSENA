import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/sena_logo.dart';
import '../widgets/barcode_generator.dart';

class IdCardScreen extends StatelessWidget {
  const IdCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Carnet Virtual',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Carnet
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(
                        color: AppColors.senaGreen,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header del carnet
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Logo SENA pequeño
                              const SenaLogo(
                                width: 110,
                                height: 80,
                              ),
                              // Foto del aprendiz
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.senaGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.senaGreen.withOpacity(0.3),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'JC',
                                    style: TextStyle(
                                      color: AppColors.senaGreen,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Información del aprendiz
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Aprendiz',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Juan Carlos Pérez García',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'ID: 1234567890',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Análisis y Desarrollo de Sistemas de Información',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Código de barras
                          const BarcodeGenerator(
                            data: '1234567890',
                            width: 200,
                            height: 60,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '1234567890',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Botón compartir
              const SizedBox(height: 24),
              CustomButton(
                text: 'Compartir Carnet',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad de compartir próximamente'),
                    ),
                  );
                },
                icon: Icons.share,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
