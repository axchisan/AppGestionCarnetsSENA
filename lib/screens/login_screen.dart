import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/sena_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identificationController = TextEditingController();
  final _passwordController = TextEditingController();
  //final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _identificationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
  }

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Logo SENA
                const SizedBox(height: 20),
                const SenaLogo(width: 150, height: 50, showShadow: false),
                const SizedBox(height: 40),

                // Título
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 40),

                // Campo número de identificación
                CustomTextField(
                  label: 'Número de Identificación',
                  hint: 'Ingresa tu número de identificación',
                  controller: _identificationController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu número de identificación';
                    }
                    if (value.length < 8) {
                      return 'El número de identificación debe tener al menos 8 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo contraseña
                CustomTextField(
                  label: 'Contraseña',
                  hint: 'Ingresa tu contraseña',
                  isPassword: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Mensaje de error
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.red.withOpacity(0.3)),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: AppColors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Botón de login
                CustomButton(
                  text: 'Iniciar Sesión',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                  icon: Icons.arrow_forward,
                ),
                const SizedBox(height: 20),

                // Enlace olvidé mi contraseña
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Contacta con la administración para recuperar tu contraseña',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Olvidé mi contraseña',
                    style: TextStyle(
                      color: AppColors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botón de registro
                CustomButton(
                  text: 'Crear Nueva Cuenta',
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  isOutlined: true,
                ),
                const SizedBox(height: 40),

                // Información adicional
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 24),
                      SizedBox(height: 8),
                      Text(
                        'Solo aprendices registrados en el centro SENA pueden crear una cuenta.',
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
