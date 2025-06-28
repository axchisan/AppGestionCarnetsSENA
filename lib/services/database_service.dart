import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/database_config.dart';
import '../models/student_model.dart';
import '../models/device_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  /// Verificar si un número de identificación está autorizado
  Future<bool> isStudentAuthorized(String numeroIdentificacion) async {
    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.serverUrl}/verify-student'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'numero_identificacion': numeroIdentificacion
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['exists'] == true;
      }
      return false;
    } catch (e) {
      print('Error verificando estudiante: $e');
      return false;
    }
  }

  /// Verificar si un estudiante ya tiene perfil creado
  Future<bool> hasProfile(String numeroIdentificacion) async {
    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.serverUrl}/check-profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'numero_identificacion': numeroIdentificacion
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['exists'] == true;
      }
      return false;
    } catch (e) {
      print('Error verificando perfil: $e');
      return false;
    }
  }

  /// Crear perfil de estudiante
  Future<bool> createStudentProfile({
    required String numeroIdentificacion,
    required String nombreCompleto,
    required String email,
    required String programaFormacion,
    required String numeroFicha,
    required String passwordHash,
    String? fotoPerfil,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.serverUrl}/create-profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'numero_identificacion': numeroIdentificacion,
          'nombre_completo': nombreCompleto,
          'email': email,
          'programa_formacion': programaFormacion,
          'numero_ficha': numeroFicha,
          'password_hash': passwordHash,
          'foto_perfil': fotoPerfil,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error creando perfil: $e');
      return false;
    }
  }

  /// Autenticar estudiante
  Future<Student?> authenticateStudent(String numeroIdentificacion, String passwordHash) async {
    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.serverUrl}/authenticate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'numero_identificacion': numeroIdentificacion,
          'password_hash': passwordHash,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['student'] != null) {
          return Student.fromDatabaseRow(data['student']);
        }
      }
      return null;
    } catch (e) {
      print('Error autenticando: $e');
      return null;
    }
  }

  /// Obtener programas de formación disponibles
  Future<List<String>> getAvailablePrograms() async {
    try {
      final response = await http.get(
        Uri.parse('${DatabaseConfig.serverUrl}/programs'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['programs'] as List).cast<String>();
      }
      return [];
    } catch (e) {
      print('Error obteniendo programas: $e');
      return [];
    }
  }

  /// Obtener dispositivos de un estudiante
  Future<List<Device>> getStudentDevices(String numeroIdentificacion) async {
    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.serverUrl}/get-devices'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'numero_identificacion': numeroIdentificacion
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['devices'] as List)
            .map((device) => Device.fromDatabaseRow(device))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo dispositivos: $e');
      return [];
    }
  }

  /// Registrar un dispositivo
  Future<bool> registerDevice({
    required String numeroIdentificacion,
    required String idDispositivo,
    required String nombreDispositivo,
    required String tipoDispositivo,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.serverUrl}/register-device'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'numero_identificacion': numeroIdentificacion,
          'id_dispositivo': idDispositivo,
          'nombre_dispositivo': nombreDispositivo,
          'tipo_dispositivo': tipoDispositivo,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error registrando dispositivo: $e');
      return false;
    }
  }

  /// Eliminar un dispositivo
  Future<bool> deleteDevice(String numeroIdentificacion, String idDispositivo) async {
    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.serverUrl}/delete-device'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'numero_identificacion': numeroIdentificacion,
          'id_dispositivo': idDispositivo,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error eliminando dispositivo: $e');
      return false;
    }
  }
}
