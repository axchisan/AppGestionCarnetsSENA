import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/student_model.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();

  Student? _currentStudent;
  Student? get currentStudent => _currentStudent;
  bool get isAuthenticated => _currentStudent != null;

  /// Inicializar servicio (verificar si hay sesión guardada)
  Future<void> initialize() async {
    final studentData = await _storageService.getStudentData();
    if (studentData != null) {
      _currentStudent = studentData;
    }
  }

  /// Verificar si un número de identificación puede registrarse
  Future<ValidationResult> validateForRegistration(String numeroIdentificacion) async {
    try {
      // 1. Verificar que esté en la lista de aprendices autorizados
      final isAuthorized = await _databaseService.isStudentAuthorized(numeroIdentificacion);
      if (!isAuthorized) {
        return ValidationResult(
          isValid: false,
          message: 'Número de identificación no autorizado. Contacta con la administración.',
        );
      }

      // 2. Verificar que no tenga ya un perfil creado
      final hasProfile = await _databaseService.hasProfile(numeroIdentificacion);
      if (hasProfile) {
        return ValidationResult(
          isValid: false,
          message: 'Ya existe una cuenta con este número de identificación.',
        );
      }

      return ValidationResult(
        isValid: true,
        message: 'Número de identificación válido para registro.',
      );
    } catch (e) {
      return ValidationResult(
        isValid: false,
        message: 'Error verificando identificación: $e',
      );
    }
  }

  /// Registrar nuevo estudiante
  Future<AuthResult> register({
    required String numeroIdentificacion,
    required String nombreCompleto,
    required String email,
    required String programaFormacion,
    required String numeroFicha,
    required String password,
    String? fotoBase64,
  }) async {
    try {
      // Validar antes de registrar
      final validation = await validateForRegistration(numeroIdentificacion);
      if (!validation.isValid) {
        return AuthResult(success: false, message: validation.message);
      }

      // Encriptar contraseña
      final passwordHash = _hashPassword(password);

      // Crear perfil en la base de datos
      final success = await _databaseService.createStudentProfile(
        numeroIdentificacion: numeroIdentificacion,
        nombreCompleto: nombreCompleto,
        email: email,
        programaFormacion: programaFormacion,
        numeroFicha: numeroFicha,
        passwordHash: passwordHash,
        fotoPerfil: fotoBase64,
      );

      if (success) {
        // Hacer login automático después del registro
        return await login(numeroIdentificacion, password);
      } else {
        return AuthResult(
          success: false,
          message: 'Error creando el perfil. Intenta nuevamente.',
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error en el registro: $e',
      );
    }
  }

  /// Iniciar sesión
  Future<AuthResult> login(String numeroIdentificacion, String password) async {
    try {
      final passwordHash = _hashPassword(password);
      
      // Autenticar con la base de datos
      final student = await _databaseService.authenticateStudent(
        numeroIdentificacion,
        passwordHash,
      );

      if (student != null) {
        _currentStudent = student;
        await _storageService.saveStudentData(student);
        await _storageService.setLoggedIn(true);

        return AuthResult(
          success: true,
          message: 'Inicio de sesión exitoso',
          student: student,
        );
      } else {
        return AuthResult(
          success: false,
          message: 'Credenciales incorrectas',
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error en el inicio de sesión: $e',
      );
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    _currentStudent = null;
    await _storageService.clearSessionData();
  }

  /// Encriptar contraseña
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

// Clases auxiliares para resultados
class ValidationResult {
  final bool isValid;
  final String message;

  ValidationResult({required this.isValid, required this.message});
}

class AuthResult {
  final bool success;
  final String message;
  final Student? student;

  AuthResult({
    required this.success,
    required this.message,
    this.student,
  });
}
