import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/sena_logo.dart';
import '../models/device_model.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identificationController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _fichaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final _authService = AuthService();
  final _databaseService = DatabaseService();
  
  String? _selectedProgram;
  List<String> _availablePrograms = [];
  bool _isLoading = false;
  bool _isValidatingId = false;
  String? _errorMessage;
  String? _validationMessage;
  bool _isIdValid = false;

  @override
  void initState() {
    super.initState();
    _loadPrograms();
  }

  @override
  void dispose() {
    _identificationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _fichaController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadPrograms() async {
    final programs = await _databaseService.getAvailablePrograms();
    setState(() {
      _availablePrograms = programs;
    });
  }

  Future<void> _validateIdentification() async {
    final identification = _identificationController.text.trim();
    if (identification.isEmpty || identification.length < 8) {
      setState(() {
        _validationMessage = 'Ingresa un número de identificación válido';
        _isIdValid = false;
      });
      return;
    }

    setState(() {
      _isValidatingId = true;
      _validationMessage = null;
      _isIdValid = false;
    });

    try {
      final result = await _authService.validateForRegistration(identification);
      setState(() {
        _validationMessage = result.message;
        _isIdValid = result.isValid;
      });
    } catch (e) {
      setState(() {
        _validationMessage = 'Error verificando identificación';
        _isIdValid = false;
      });
    } finally {
      setState(() {
        _isValidatingId = false;
      });
    }
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate() || !_isIdValid) {
      if (!_isIdValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Primero valida tu número de identificación'),
            backgroundColor: AppColors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _authService.register(
        numeroIdentificacion: _identificationController.text.trim(),
        nombreCompleto: _nameController.text.trim(),
        email: _emailController.text.trim(),
        programaFormacion: _selectedProgram!,
        numeroFicha: _fichaController.text.trim(),
        password: _passwordController.text,
      );

      if (result.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro exitoso'),
              backgroundColor: AppColors.senaGreen,
            ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          _errorMessage = result.message;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error en el registro: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        title: const SenaLogo(
          width: 120,
          height: 40,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                const Center(
                  child: Text(
                    'Registro de Aprendiz',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Campo número de identificación con validación
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
                      return 'El número debe tener al menos 8 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Botón de validación
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Validar Identificación',
                        onPressed: _validateIdentification,
                        isLoading: _isValidatingId,
                        isOutlined: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Mensaje de validación
                if (_validationMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isIdValid 
                          ? AppColors.senaGreen.withOpacity(0.1)
                          : AppColors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isIdValid 
                            ? AppColors.senaGreen.withOpacity(0.3)
                            : AppColors.red.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isIdValid ? Icons.check_circle : Icons.error,
                          color: _isIdValid ? AppColors.senaGreen : AppColors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _validationMessage!,
                            style: TextStyle(
                              color: _isIdValid ? AppColors.senaGreen : AppColors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Resto del formulario (solo habilitado si la ID es válida)
                Opacity(
                  opacity: _isIdValid ? 1.0 : 0.5,
                  child: IgnorePointer(
                    ignoring: !_isIdValid,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Nombre Completo',
                          hint: 'Ingresa tu nombre completo',
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu nombre completo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          label: 'Correo Electrónico',
                          hint: 'ejemplo@correo.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu correo electrónico';
                            }
                            if (!value.contains('@')) {
                              return 'Ingresa un correo válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Dropdown para programa
                        const Text(
                          'Programa de Formación',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedProgram,
                          decoration: InputDecoration(
                            hintText: 'Selecciona tu programa',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.senaGreen,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.senaGreen,
                                width: 2,
                              ),
                            ),
                          ),
                          items: _availablePrograms.map((String program) {
                            return DropdownMenuItem<String>(
                              value: program,
                              child: Text(program),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedProgram = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor selecciona un programa';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          label: 'Número de Ficha',
                          hint: 'Número de ficha del programa',
                          controller: _fichaController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa el número de ficha';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          label: 'Contraseña',
                          hint: 'Crea una contraseña',
                          isPassword: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa una contraseña';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          label: 'Confirmar Contraseña',
                          hint: 'Confirma tu contraseña',
                          isPassword: true,
                          controller: _confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor confirma tu contraseña';
                            }
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

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

                        // Botón de registro
                        CustomButton(
                          text: 'Registrarse',
                          onPressed: _handleRegistration,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 20),

                        // Enlace a login
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              '¿Ya tienes cuenta? Inicia sesión',
                              style: TextStyle(
                                color: AppColors.senaGreen,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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