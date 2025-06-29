import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crypto/crypto.dart'; // Para hashing
import 'dart:convert'; // Para utf8.encode
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/sena_logo.dart';
import '../services/database_service.dart';
import '../models/models.dart';

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
  final _deviceController = TextEditingController();
  final _tipoSangreController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _selectedProgram;
  bool _isLoading = false;
  bool _isValidatingId = false;
  bool _isIdValid = false;
  List<String> _devices = [];
  String? _fotoPerfilPath;

  final List<String> _programs = [
    'ADSI - Análisis y Desarrollo de Sistemas',
    'Multimedia - Producción Multimedia',
    'Contabilidad - Contabilidad y Finanzas',
    'Mercadeo - Mercadeo y Ventas',
    'Gestión - Gestión Administrativa',
    'Redes - Mantenimiento de Equipos de Cómputo',
    'Diseño - Diseño Gráfico',
    'Cocina - Cocina Internacional',
  ];

  final DatabaseService _dbService = DatabaseService();

  @override
  void dispose() {
    _identificationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _fichaController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _deviceController.dispose();
    _tipoSangreController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _fotoPerfilPath = image.path;
      });
    }
  }

  void _validateIdentification() async {
    if (_identificationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un número de identificación'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() {
      _isValidatingId = true;
    });

    final isValid = await _dbService.validateIdentification(_identificationController.text.trim());
    if (mounted) {
      setState(() {
        _isValidatingId = false;
        _isIdValid = isValid;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isValid ? 'Número de identificación válido' : 'Número no registrado en el SENA'),
          backgroundColor: isValid ? AppColors.senaGreen : AppColors.red,
        ),
      );
    }
  }

  void _addDevice() {
    if (_deviceController.text.trim().isNotEmpty) {
      setState(() {
        _devices.add(_deviceController.text.trim());
        _deviceController.clear();
      });
    }
  }

  void _removeDevice(int index) {
    setState(() {
      _devices.removeAt(index);
    });
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convertir a bytes
    var digest = sha256.convert(bytes); // Usar SHA-256 (puedes cambiar a MD5 o bcrypt)
    return digest.toString();
  }

  void _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isIdValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero valida tu número de identificación'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    if (_selectedProgram == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un programa de formación'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final hashedPassword = _hashPassword(_passwordController.text.trim());
    final aprendiz = Aprendiz(
      idIdentificacion: _identificationController.text.trim(),
      nombreCompleto: _nameController.text.trim(),
      programaFormacion: _selectedProgram!,
      numeroFicha: _fichaController.text.trim(),
      tipoSangre: _tipoSangreController.text.trim().isNotEmpty ? _tipoSangreController.text.trim() : null,
      fotoPerfilPath: _fotoPerfilPath,
      contrasena: hashedPassword,
      email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      fechaRegistro: DateTime.now(),
      dispositivos: _devices.map((d) => Dispositivo(
        idDispositivo: DateTime.now().millisecondsSinceEpoch + _devices.indexOf(d),
        idIdentificacion: _identificationController.text.trim(),
        nombreDispositivo: d,
        fechaRegistro: DateTime.now(),
      )).toList(),
    );

    try {
      await _dbService.saveAprendiz(aprendiz);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso'),
            backgroundColor: AppColors.senaGreen,
          ),
        );
        Navigator.pushReplacementNamed(context, '/inicio', arguments: aprendiz);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar: $e'),
            backgroundColor: AppColors.red,
          ),
        );
      }
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Validar Identificación',
                  onPressed: _validateIdentification,
                  isLoading: _isValidatingId,
                  isOutlined: true,
                ),
                const SizedBox(height: 16),
                if (_isIdValid) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.senaGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.senaGreen.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.senaGreen,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Número de identificación válido',
                            style: TextStyle(
                              color: AppColors.senaGreen,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                AnimatedOpacity(
                  opacity: _isIdValid ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: AbsorbPointer(
                    absorbing: !_isIdValid,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const Text(
                          'Programa de Formación',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.senaGreen,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedProgram,
                              hint: const Text('Selecciona tu programa'),
                              isExpanded: true,
                              items: _programs.map((String program) {
                                return DropdownMenuItem<String>(
                                  value: program,
                                  child: Container(
                                    constraints: const BoxConstraints(maxWidth: 250),
                                    child: Text(
                                      program,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedProgram = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                        if (_selectedProgram == null) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Por favor selecciona un programa',
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
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
                          label: 'Tipo de Sangre',
                          hint: 'Ej: A+, O-, AB+',
                          controller: _tipoSangreController,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Foto de Perfil',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomButton(
                          text: 'Subir Foto',
                          onPressed: _pickImage,
                          isOutlined: true,
                          icon: Icons.camera_alt,
                        ),
                        if (_fotoPerfilPath != null) ...[
                          const SizedBox(height: 8),
                          Image.file(File(_fotoPerfilPath!), height: 100),
                        ],
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
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: AppColors.gray.withOpacity(0.3),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Dispositivos Autorizados (Opcional)',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _deviceController,
                                decoration: InputDecoration(
                                  hintText: 'ID del dispositivo (ej: PC001)',
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
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.senaGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: _addDevice,
                                icon: const Icon(Icons.add, color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_devices.isNotEmpty) ...[
                          Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _devices.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGray,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.devices, color: AppColors.senaGreen),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _devices[index],
                                          style: const TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _removeDevice(index),
                                        icon: const Icon(Icons.delete, color: AppColors.red),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        CustomButton(
                          text: 'Registrarse',
                          onPressed: _handleRegistration,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 40),
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